class Backend::BackendController < ApplicationController
  #TODO override# require_role "inventory_manager" #, :except => [:create_some, # TODO for temporary_controller
                                   #                     :login, :switch_inventory_pool] # TODO for rspec tests
  
  before_filter :init, :except => :create_some # TODO for temporary_controller  # TODO not needed for modal layout
  
  $theme = '00-patterns'
  $modal_layout_path = 'backend/' + $theme + '/modal'
  $general_layout_path = 'backend/' + $theme + '/general'
  $layout_public_path = '/layouts/' + $theme
  
  layout $general_layout_path
 
###############################################################  
   # add a new line
   def generic_add_line(document, render_id)
    if request.post?
      params[:quantity] ||= 1
      document.add_line(params[:quantity].to_i, Model.find(params[:model_id]), params[:user_id])
      flash[:notice] = _("Model couldn't be added") unless document.save        
      redirect_to :action => 'show', :id => render_id        
    else
      redirect_to :controller => '/models', 
                  :action => 'search',
                  :id => params[:id],
                  :source_controller => params[:controller],
                  :source_action => params[:action]
    end
  end


  # swap model for a given line
  def generic_swap_model_line(document, render_id)
    if request.post?
      if params[:model_id].nil?
        flash[:notice] = _("Model must be selected")
      else
        document.swap_line(params[:line_id], params[:model_id], session[:user_id])
      end  
      redirect_to :action => 'show', :id => render_id        
    else
      redirect_to :controller => '/models', 
                  :action => 'search',
                  :id => params[:id],
                  :line_id => params[:line_id],
                  :source_controller => params[:controller],
                  :source_action => params[:action]
    end
  end
  
  # change time frame for OrderLines or ContractLines 
  def generic_time_lines(document, render_id)
    if request.post?
      begin
        start_date = Date.new(params[:line]['start_date(1i)'].to_i, params[:line]['start_date(2i)'].to_i, params[:line]['start_date(3i)'].to_i)
        end_date = Date.new(params[:line]['end_date(1i)'].to_i, params[:line]['end_date(2i)'].to_i, params[:line]['end_date(3i)'].to_i)
        params[:lines].each {|l| document.update_time_line(l, start_date, end_date, session[:user_id]) }
      rescue
        flash[:notice] = "Invalid date" #TODO 
      end 
        render :action => 'show', :id => render_id
    else
      @lines = document.lines.find(params[:lines].split(','))
      render :template => 'backend/backend/time_lines', :layout => $modal_layout_path
    end   
  end    
  
  # remove OrderLines or ContractLines
  def generic_remove_lines(document, render_id)
     if request.post?
        params[:lines].each {|l| document.remove_line(l, session[:user_id]) }
        redirect_to :action => 'show', :id => render_id
    else
      @lines = document.lines.find(params[:lines].split(','))
      render :template => 'backend/backend/remove_lines', :layout => $modal_layout_path
    end   
  end    
###############################################################  

  
  private
  
  def init
    # OPTIMIZE select most recent used inventory pool
    if logged_in?
      unless self.current_inventory_pool
        first_access_right = current_user.access_rights.detect {|a| a.role.name == 'inventory_manager'}
        self.current_inventory_pool = first_access_right.inventory_pool if first_access_right
      end
    else
      session[:return_to] = request.request_uri
      redirect_to :controller => '/session', :action => 'new' and return
    end

    @current_inventory_pool = current_inventory_pool

#    if @current_inventory_pool
      @submitted_orders_size = @current_inventory_pool.orders.submitted_orders.size
      @new_contracts_size = @current_inventory_pool.hand_over_visits.size
      @signed_contracts_size = @current_inventory_pool.take_back_visits.size
      @remind_contracts_size = @current_inventory_pool.remind_visits.size
#    end

  end
  
  def set_order_to_session(order)
    session[:current_order] = { :id => order.id,
                                :user_login => order.user.login }
  end
  
  def remove_order_from_session
    session[:current_order] = nil
  end
  
end
