#### source: https://tomafro.net/2009/09/quickly-list-missing-foreign-key-indexes
#
#c = ActiveRecord::Base.connection
#c.tables.collect do |t|
#  columns = c.columns(t).collect(&:name).select {|x| x.ends_with?("_id" || x.ends_with("_type"))}
#  indexed_columns = c.indexes(t).collect(&:columns).flatten.uniq
#  unindexed = columns - indexed_columns
#  unless unindexed.empty?
#    puts "#{t}: #{unindexed.join(", ")}"
#  end
#end

class Admin::DatabaseController < Admin::ApplicationController

  before_filter do
    @connection = ActiveRecord::Base.connection
  end

  def indexes
    @indexes_found, @indexes_not_found = begin
      [
          ["access_rights", ["deleted_at"]],
          ["access_rights", ["inventory_pool_id"]],
          ["access_rights", ["suspended_until"]],
          ["access_rights", ["user_id", "inventory_pool_id", "deleted_at"]],
          ["accessories", ["model_id"]],
          ["accessories_inventory_pools", ["accessory_id", "inventory_pool_id"], :unique => true],
          ["accessories_inventory_pools", ["inventory_pool_id"]],
          ["addresses", ["street", "zip_code", "city", "country_code"], :unique => true],
          ["attachments", ["model_id"]],
          # ["audits", ["associated_id", "associated_type"]],
          # ["audits", ["auditable_id", "auditable_type"]],
          # ["audits", ["created_at"]],
          # ["audits", ["thread_id"]],
          # ["audits", ["user_id", "user_type"]],
          ["contract_lines", ["contract_id"]],
          ["contract_lines", ["end_date"]],
          ["contract_lines", ["item_id"]],
          ["contract_lines", ["model_id"]],
          ["contract_lines", ["option_id"]],
          ["contract_lines", ["returned_date", "contract_id"]],
          ["contract_lines", ["start_date"]],
          ["contract_lines", ["type", "contract_id"]],
          ["contracts", ["inventory_pool_id"]],
          ["contracts", ["status"]],
          ["contracts", ["user_id"]],
          ["groups", ["inventory_pool_id"]],
          ["groups_users", ["group_id"]],
          ["groups_users", ["user_id", "group_id"], :unique => true],
          ["histories", ["target_type", "target_id"]],
          ["histories", ["type_const"]],
          ["histories", ["user_id"]],
          ["holidays", ["inventory_pool_id"]],
          ["holidays", ["start_date", "end_date"]],
          ["images", ["target_id", "target_type"]],
          ["inventory_pools", ["name"], :unique => true],
          ["inventory_pools_model_groups", ["inventory_pool_id"]],
          ["inventory_pools_model_groups", ["model_group_id"]],
          ["items", ["inventory_code"], :unique => true],
          ["items", ["inventory_pool_id"]],
          ["items", ["is_borrowable"]],
          ["items", ["is_broken"]],
          ["items", ["is_incomplete"]],
          ["items", ["location_id"]],
          ["items", ["model_id", "retired", "inventory_pool_id"]],
          ["items", ["owner_id"]],
          ["items", ["parent_id", "retired"]],
          ["items", ["retired"]],
          ["languages", ["active", "default"]],
          ["languages", ["name"], :unique => true],
          ["locations", ["building_id"]],
          ["model_group_links", ["ancestor_id"]],
          ["model_group_links", ["descendant_id", "ancestor_id", "direct"]],
          ["model_group_links", ["direct"]],
          ["model_groups", ["type"]],
          ["model_links", ["model_group_id", "model_id"]],
          ["model_links", ["model_id", "model_group_id"]],
          ["models", ["is_package"]],
          ["models_compatibles", ["compatible_id"]],
          ["models_compatibles", ["model_id"]],
          ["notifications", ["user_id"]],
          ["options", ["inventory_pool_id"]],
          ["partitions", ["model_id", "inventory_pool_id", "group_id"], :unique => true],
          ["properties", ["model_id"]],
          ["users", ["authentication_system_id"]],
          ["workdays", ["inventory_pool_id"]]
      ].partition do |table, columns, options|
        indexes = @connection.indexes(table)
        index = indexes.detect { |x| x.columns == columns }
        if not index
          false
        elsif options.blank?
          true
        else
          index.unique == !!options[:unique]
        end
      end
    end
  end

  def consistency
    @only_tables_no_views = @connection.execute("SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'").to_h.keys

    @missing_references = {}

    def left_join_query(klass, other_table, this_table, this_column, other_column, additional_where = nil)
      # NOTE we skip references on sql-views
      return if not @only_tables_no_views.include?(this_table) or not @only_tables_no_views.include?(other_table)

      r = klass.unscoped.
          joins("LEFT JOIN %s AS t2 ON %s.%s = t2.%s" % [other_table, this_table, this_column, other_column]).
          where.not(this_column => nil).
          where(t2: {other_column => nil})
      r = r.where(additional_where) if additional_where
      unless r.empty?
        @missing_references["%s with missing %s" % [this_table, other_table.singularize]] = r
        # @missing_references[r.to_sql] = r
      end
    end

    Rails.application.eager_load! if Rails.env.development?

    ActiveRecord::Base.descendants.each do |klass|
      klass.reflect_on_all_associations(:belongs_to).each do |ref|
        if ref.polymorphic?
          # NOTE we cannot define foreign keys on multiple parent tables
          klass.unscoped.group(:target_type).map(&:target_type).flat_map do |target_type|
            target_klass = target_type.constantize
            left_join_query(klass, target_klass.table_name, klass.table_name, ref.foreign_key, target_klass.primary_key, {target_type: target_type})
          end
        else
          left_join_query(klass, ref.table_name, klass.table_name, ref.foreign_key, ref.primary_key_column.name)
        end
      end
    end

    ActiveRecord::Base.descendants.each do |klass|
      klass.reflect_on_all_associations(:has_and_belongs_to_many).each do |ref|
        r = klass.unscoped.
              joins("INNER JOIN %s AS t2 ON %s.%s = t2.%s" % [ref.join_table, klass.table_name, ref.primary_key_column.name, ref.foreign_key]).
              joins("LEFT JOIN %s AS t3 ON t2.%s = t3.%s" % [ref.klass.table_name, ref.association_foreign_key, ref.association_primary_key]).
              where(t3: {ref.association_primary_key => nil})
        unless r.empty?
          @missing_references["%s with missing %s (through %s join table)" % [klass.table_name, ref.klass.table_name, ref.join_table]] = r
        end
      end
    end

  end

  def empty_columns
    @empty_columns = {}
    @connection.tables.each do |table_name|
      @connection.columns(table_name).select { |c| c.type == :string and c.null }.each do |column|
        r = @connection.execute(%Q(SELECT * FROM `#{table_name}` WHERE `#{column.name}` REGEXP '^\ *$')).to_a
        next if r.empty?
        @empty_columns[[table_name, column.name]] = r
      end
    end
  end

end
