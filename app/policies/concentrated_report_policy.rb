class ConcentratedReportPolicy
  attr_accessor :months, :months_strings, :type, :all_total

  def initialize(type)
    @months_strings = %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
    @type = type
    @all_total = BigDecimal.new("0.00", 2)
  end

  def all_months(year)
    months = generate_month_starter_by(year)
    concentrated = []

    months.each_with_index do |start_month, index|
      incomes = incomes_by(start_month)
      total = obtain_total(incomes)

      concentrated << {
        month: months_strings[index] + " " + year.to_s,
        amount: total
      }
    end

    return concentrated
  end

  def one_month(date)
    months = generate_by(date)
    concentrated = []

    months.each do |start_month|
      incomes = incomes_by(start_month)
      total = obtain_total(incomes)

      concentrated << {
        month: months_strings[date.month - 1] + " " + date.year.to_s,
        amount: total
      }
    end

    return concentrated
  end

  def months_select
    return [
      ["Enero", 1],
      ["Febrero", 2],
      ["Marzo", 3],
      ["Abril", 4],
      ["Mayo", 5],
      ["Junio", 6],
      ["Julio", 7],
      ["Agosto", 8],
      ["Septiembre", 9],
      ["Octubre", 10],
      ["Noviembre", 11],
      ["Diciembre", 12]
    ]
  end

  def years_select
    years = []
    current_year = Date.current.year
    (1..5).each do |i|
      years << current_year
      current_year -= 1
    end

    return years
  end

  private

  def generate_month_starter_by(year)
    return @months if @months.present?

    @months = []
    first_month = Date.new(year, 1, 1)
    @months << first_month
    prev_month = first_month

    (1...12).each do
      prev_month = prev_month.next_month
      @months << prev_month
    end

    return @months
  end

  def generate_by(date)
    return @months if @months.present?

    @months = []
    first_month = Date.new(date.year, date.month, 1)
    @months << first_month
    return @months
  end

  def incomes_by(date)
    case type
    when "services"
      type_object = Payment
    when "sales"
      type_object = Sale
    when "printing_sales"
      type_object = PrintingSale
    when "quotation_printings"
      type_object = QuotationPrinting
    end

    incomes_ids = type_object
      .select do |income|
        income.updated_at.to_date >= date && income.updated_at.to_date < date.next_month
      end
      .map(&:id)

    incomes = type_object
      .where("id IN (?)", incomes_ids)

    return incomes
  end

  def obtain_total(incomes)
    case type
    when "services"
      total = Payment.total(incomes)
    when "sales"
      total =  Sale.total(incomes)
    when "printing_sales"
      total =  PrintingSale.parcial(incomes)
      incomes.each do |income|
        total += income.total_parcial_payments
      end
    when "quotation_printings"
      total = QuotationPrinting.total(incomes)
    end

    if total.nil?
      total = BigDecimal.new("0.00", 2)
    end

    @all_total += total

    return total
  end

end
