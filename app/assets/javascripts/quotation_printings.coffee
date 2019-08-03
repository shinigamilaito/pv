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
    @category = @wrapperForm.find("[data-behavior='category']")
    @item.find("[data-behavior='open-carousel']").on "click", @handleOpenCarousel
    Utils.setDatePicker()

  handleOpenCarousel: (e) =>
    category_id = @category.find("option:selected").val()
    if category_id
      $.ajax
        url: "/quotation_printings/data_carousel?category_id=#{category_id}"
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
    @modal.find("[data-behavior='subcategory']").on "change", @handleSubcategoryChange
    @setLighBoxEvent()

  handleSubcategoryChange: (e) =>
    subcategory_id = $(e.target).find("option:selected").val()
    if subcategory_id
      $.ajax
        url: "/quotation_printings/data_carousel?subcategory_id=#{subcategory_id}"
        method: "get"
        dataType: "json"
        beforeSend: (xhr) ->
          $("body").LoadingOverlay("show")
        success: @handleSubcategoryChangeSuccess
        complete: (xhr) ->
          $("body").LoadingOverlay("hide", true)

  handleSubcategoryChangeSuccess: (response) =>
    console.log(response.data)
    @modal.find("[data-behavior='gallery']").html(response.data)
    @setLighBoxEvent()

  setLighBoxEvent: =>
    @modalBody.find("[data-toggle='lightbox']").on "click", @handleLightBox

  handleLightBox: (e) =>
    e.preventDefault()
    @currentImage = $(e.currentTarget)
    console.log("Index in current Image #{@currentImage.data("position-carousel")} Id Invitation #{@currentImage.data("invitation-id")}")
    console.log("In handleLightBox")
    console.log(e)
    console.log($(e.currentTarget).html())
    $(e.currentTarget).ekkoLightbox({
#alwaysShowClose: true
      onContentLoaded: (e) =>
        console.log('onContentLoaded' + e)
      onShow: (e) =>
        console.log(e)
      onHide: (e) =>
        console.log($(this))
      onHidden: (e) =>
        console.log('onHidden' + e)
      onShown: (e) =>
        console.log('Checking our the events huh?' + e);
      onNavigate: (direction, itemIndex) =>
        @currentImage = $(@modalBody.find("[data-toggle='lightbox']")[itemIndex])
        console.log('Navigating ' + direction + '. Current item: ' + itemIndex);
        console.log("Index in current Image #{@currentImage.data("position-carousel")} Id Invitation #{@currentImage.data("invitation-id")}")
    })

######

jQuery ->
  console.log("QuoationPrinting file is loaded....")
  $.map $("[data-behavior='quotation-printing']"), (item) ->
    console.log("Iterating QuotationPrinting")
    new QuotationPrinting(item)