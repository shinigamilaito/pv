module ApplicationHelper
  def root_controller()
    current_page?(root_url) ? 'active-sidebar' : ''
  end

  def date_time_helper(datetime)
    l datetime, format: '%A, %d %b %Y %I:%M:%S'
    #datetime.strftime('%A, %d %b %Y %I:%M:%S')
  end

  def collapse_menu_store?(section)
    if section.eql?("Ventas") || section.eql?("Cotizar") || section.eql?("Cotizaciones")
      return "display: block;"
    else
      return "display: none;"
    end
  end

  def collapse_menu_services?(section)
    if section.eql?("Servicios") || section.eql?("Servicios Proceso")
      return "display: block;"
    else
      return "display: none;"
    end
  end

  def collapse_menu_catalogs?(section)
    sections = %w(Equipos Marcas Modelos Refacciones Empleados Productos
                  Clientes printing_products Invitaciones categories
                  subcategories content_for_invitations)

    sections << 'Precios Genéricos'

    if sections.include?(section)
      return "display: block;"
    else
      return "display: none;"
    end
  end

  def collapse_menu_incomes?(section)
    sections = %w(incomes incomes_sales concentrated_reports_sales concentrated_reports_services
                  cash_movements product_earnings_report incomes_printing incomes_quotation_printing)

    if sections.include?(section)
      return "display: block;"
    else
      return "display: none;"
    end
  end

  def collapse_menu_cashes?(section)
    sections = %w(open_cashes close_cashes movements_cash)

    if sections.include?(section)
      return "display: block;"
    else
      return "display: none;"
    end
  end

  def collapse_menu_printing_sales?(section)
    sections = %w(VentasImpresiones VentasParciales quotation_printing quotation_printings)

    if sections.include?(section)
      return "display: block;"
    else
      return "display: none;"
    end
  end

end
