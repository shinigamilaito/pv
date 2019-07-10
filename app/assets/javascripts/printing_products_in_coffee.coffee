class Utils
  @inputMaskCurrency: (item, options) ->
    $(item).inputmask("currency", options)

  @inputMaskInteger: (item, options) ->
    $(item).inputmask("integer", options);

class PrintingProductForm
  constructor: (item) ->
    @$item = $(item)
    @initialize()
    @setEvents()

  initialize: ->
    $.map @$item.find("[data-input-mask='currency-input']"), (item) ->
      Utils.inputMaskCurrency(item, {rightAlign: false})

    $.map @$item.find("[data-input-mask='integer-input']"), (item) ->
      Utils.inputMaskInteger(item, {rightAlign: false})

    @$purchase_price = @$item.find("[data-behavior='purchase-price']")
    @$content = @$item.find("[data-behavior='content']")
    @$sale_price = @$item.find("[data-behavior='sale-price']")
    @$utility = @$item.find("[data-behavior='utility']")

  setEvents: ->
    [@$purchase_price, @$content, @$sale_price].forEach((element) ->
      console.log("Element listener keyup: #{element.val()}")
      element.on "keyup", @handleToggle
    , @)

  handleToggle: =>
    sale_price = parseFloat @$sale_price.val().slice(1).trim()
    purchase_price = parseFloat @$purchase_price.val().slice(1).trim()
    content = parseFloat @$content.val().trim()

    if isNaN(sale_price) || isNaN(purchase_price) || isNaN(content)
      @$utility.val('')
    else
      @$utility.val(content * sale_price - purchase_price)

jQuery ->
  console.log("Printing Products file is loaded....")
  $.map $("[data-behavior='printing-product-form']"), (item) ->
    new PrintingProductForm(item)