class PartialSalesPolicy
  attr_accessor :client_id

  def initialize(client_id = '')
    @client_id = client_id
  end

  def find_partial_sales
    printing_sales = PrintingSale
      .where(client_id: client_id, full_payment: false)
      .order(created_at: :desc)

    partial_sales_hash = {}
    partial_sales_hash[:partial_sales] = printing_sales.map(&:ticket)
    partial_sales_hash[:partial_sales_present] = printing_sales.map do |printing_sale|
       partial_sales_with_date_creation(printing_sale)
    end

    partial_sales_hash
  end

  def partial_sales_with_date_creation(printing_sale)
    date = ActionController::Base.helpers.l(printing_sale.created_at, format: '%A, %d %b %Y %I:%M:%S')
    return "#{printing_sale.ticket} - Creado: #{date}."
  end

  def total(printing_sale)
    printing_sale.total
  end

  def total_payments(printing_sale)
    payment = printing_sale.payment
    payment += printing_sale.partial_sales.map(&:payment).sum()

    return payment
  end

end
