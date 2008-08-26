# Superclass for OrderLine and ContractLine
class DocumentLine < ActiveRecord::Base
  self.abstract_class = true
  
  before_validation_on_create :set_defaults
  validate :date_sequence  
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0, :only_integer => true 

###############################################  
  
  def self.current_and_future_reservations(model_id, document_line = nil, date = Date.today)
    cl = ContractLine.find(:all, :conditions => ['model_id = ? and ((start_date < ? and end_date > ?) or start_date > ?) and id <> ?', model_id, date, date, date, document_line ? document_line.contract_to_exclude : 0])
    ol = OrderLine.find(:all,
                        :joins => :order,
                        :conditions => ['model_id = ? and ((start_date < ? and end_date > ?) or start_date > ?) and order_lines.id <> ? and orders.status_const = ?', model_id, date, date, date, document_line ? document_line.order_to_exclude : 0, Order::SUBMITTED])
    cl + ol
  end

  # compares two objects in order to sort them
  def <=>(other)
    self.start_date <=> other.start_date
  end

  def available?
    model.maximum_available_in_period(start_date, end_date, self) >= quantity
  end
  
  private
  
  def set_defaults
    self.start_date ||= Date.today
    self.end_date ||= Date.today
  end

  def date_sequence
    # OPTIMIZE strange behavior: in some cases, this error raises when shouldn't 
    errors.add_to_base(_("Start Date must be before End Date")) if end_date < start_date
   #TODO: Think about this a little bit more.... errors.add_to_base(_("Start Date cannot be a past date")) if start_date < Date.today
  end


end
