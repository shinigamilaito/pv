class QuotationPrinting
  constructor: (item) ->
    console.log("QuotationPrinting Form created")
    @item = $(item)
    @selectClients = @item.find("[data-behavior='clients-autocomplete']")
    @selectNumberFolio = @item.find("[data-behavior='select-number-folio']")
    @buttonRegister = @item.find("[data-behavior='quotation-register']")
    @wrapperForm = @item.find("[data-behavior='wrapper-quotation-printing']")
    @initialize()
    @setEvents()

  initialize: ->
    Utils.clientsAutocomplete()

  setEvents: ->
    console.log("Set Event change")
    @selectClients.on "select2:select", @handleClientChange
    @buttonRegister.on "click", @handleLoadForm

  handleClientChange: (e) =>
    data = e.params.data;

    $.ajax(
      url: "/quotation_printings/find_quotation_printings_by_client"
      method: "get"
      dataType: "json"
      data:
        client: data
      beforeSend: ->
        $("#quotation_printing").LoadingOverlay("show")
      success: @handleClientChangeSuccess
      complete: ->
        $("#quotation_printing").LoadingOverlay("hide", true)
    )

  handleClientChangeSuccess: (data) =>
    @item.find("[data-behavior='div-quotation-printings']").html(data.quotation_printing)
    @selectNumberFolio = @item.find("[data-behavior='select-number-folio']")
    @selectNumberFolio.select2()
    @buttonRegister.removeClass "disabled"

  handleLoadForm: =>
    $.ajax
      url: "/quotation_printings/new"
      method: "get"
      dataType: "json"
      data:
        number_folio: @selectNumberFolio.find("option:selected").val().split(' - ')[0]
        client_id: @selectClients.find("option:selected").val()
      beforeSend: (xhr) ->
        $("body").LoadingOverlay("show")
      success: @handleLoadFormSuccess
      complete: (xhr) ->
        $("body").LoadingOverlay("hide", true)

  handleLoadFormSuccess: (data) =>
    @wrapperForm.html data.quotation_printing
    @item.find("[data-behavior='open-carousel']").on "click", @handleOpenCarousel
    Utils.setDatePicker()

  handleOpenCarousel: (e) =>
    $.ajax
      url: "/quotation_printings/data_carousel"
      method: "get"
      dataType: "json"
      beforeSend: (xhr) ->
        $("body").LoadingOverlay("show")
      success: @showModal
      complete: (xhr) ->
        $("body").LoadingOverlay("hide", true)

  showModal: (response) =>
    modal = @item.find("[data-behavior='modal']")
    modalBody = modal.find("[data-behavior='modal-body']")
    modalBody.html(response.data)

    @carousel = new Carousel

class Carousel
  constructor: ->
    console.log("Carousel created")
    @modal = $("[data-behavior='modal']")
    @modalBody = @modal.find("[data-behavior='modal-body']")
    @initialize()
    @setEvents()

  initialize: ->
    @modal.modal('show')

  setEvents: ->
    @modal.find("[data-behavior='category']").on "change", @handleCategoryChange

  handleCategoryChange: (e) =>
    $option = $(e.target).find("option:selected")
    alert("Mostrar muestras para #{$option.text()}")

jQuery ->
  console.log("QuoationPrinting file is loaded....")
  $.map $("[data-behavior='quotation-printing']"), (item) ->
    console.log("Iterating QuotationPrinting")
    new QuotationPrinting(item)