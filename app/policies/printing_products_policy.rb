class PrintingProductsPolicy

  def self.sale_units
    return %w(Pieza Paquete Metro Bolsa Caja Juego Rollo)
  end

  def self.contains_unit
    return %w(Piezas Metros)
  end
end
