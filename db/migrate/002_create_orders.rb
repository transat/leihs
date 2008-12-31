class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.belongs_to :user
      t.belongs_to :inventory_pool
      t.integer :status_const, :default => Order::NEW 
      t.string :purpose
      t.timestamps
    end
    add_index(:orders, :status_const)

    #execute "alter table orders add constraint fk_order_user foreign key (user_id) references users(id)"

    # TODO acts_as_backupable
    create_table :backup_orders do |t|
      t.belongs_to :order   # reference to orginal
      t.belongs_to :user
      t.belongs_to :inventory_pool
      t.integer :status_const, :default => Order::NEW 
      t.string :purpose
      t.timestamps
    end
    add_index(:backup_orders, :status_const)
     
     
  end

  def self.down
    drop_table :orders

    drop_table :backup_orders # TODO acts_as_backupable
  end
end
