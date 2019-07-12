class PrintingProductForm
  constructor: (item) ->
    @$item = $(item)
    @initialize()
    @setEvents()

  initialize: ->
    @.inputsMask()
    @.imageLoad()

    @$purchase_price = @$item.find("[data-behavior='purchase-price']")
    @$content = @$item.find("[data-behavior='content']")
    @$sale_price = @$item.find("[data-behavior='sale-price']")
    @$utility = @$item.find("[data-behavior='utility']")

  setEvents: ->
    @$item.find("[data-behavior='file-imagen']").on "change", @handleImage

    [@$purchase_price, @$content, @$sale_price].forEach((element) ->
      console.log("Element listener keyup: #{element.val()}")
      element.on "keyup", @handleContent
    , @)

  handleContent: =>
    sale_price = parseFloat @$sale_price.val().slice(1).trim()
    purchase_price = parseFloat @$purchase_price.val().slice(1).trim()
    content = parseFloat @$content.val().trim()

    if isNaN(sale_price) || isNaN(purchase_price) || isNaN(content)
      @$utility.val('')
    else
      @$utility.val(content * sale_price - purchase_price)

  handleImage: (event) =>
    console.log("Calling Util.readURL from: handleImage")
    Utils.readURL(event.target, @$imagen)

  inputsMask: ->
    Utils.inputsMask({rightAlign: false})

  imageLoad: ->
    @$fileImagenCache = @$item.find("[data-behavior='file-imagen-cache']")
    @$imagen = @$item.find("[data-behavior='imagen']")

    console.log("Calling Util.readURL from: imageLoad")
    Utils.readURL(@$fileImagenCache, @$imagen)

jQuery ->
  console.log("Printing Products file is loaded....")
  $.map $("[data-behavior='printing-product-form']"), (item) ->
    new PrintingProductForm(item)