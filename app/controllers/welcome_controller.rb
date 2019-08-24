class WelcomeController < ApplicationController
  def index
    @module = "Home"
    @items = ItemsByFinish.new(current_user)
      .elements
      #.paginate(page: params[:page], per_page: self.elements_per_page)

    #@index = obtain_index(params[:page].to_i)

    if params[:method_name].present? && params[:method_name] == 'close_cash'
      @cash = params[:cash]
      @type = params[:type]
      @get_xlsx_close_cash = true
    end

    if params[:method_name].present? && params[:method_name] == 'open_cash'
      @cash = params[:cash]
      @type = params[:type]
      @print_ticket_open_cash = true
    end
  end
end
