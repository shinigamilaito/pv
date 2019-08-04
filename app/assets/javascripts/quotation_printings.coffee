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
    console.log("In handleLightBox")
    $(e.currentTarget).ekkoLightbox({
#alwaysShowClose: true
      onContentLoaded: (e) =>
        @setClicImage()
      onShow: (e) =>
        console.log('onShow' + e)
      onHide: (e) =>
        console.log('onHide' + e)
      onHidden: (e) =>
        console.log('onHidden' + e)
      onShown: (e) =>
        console.log('onShown Checking our the events huh?' + e);
      onNavigate: (direction, itemIndex) =>
        console.log('Navigating ' + direction + '. Current item: ' + itemIndex);
    })

  setClicImage: =>
    console.log("setclickImageMthod")
    $(document).off "click", "[data-behavior='select-image']"
    $(document).on "click", "[data-behavior='select-image']", @handleSelectImage

  handleSelectImage: (e) =>
    invitation_id = $(e.target).data("invitation-id")
    imagen_url = $(e.target).data("image-url")
    $(".ekko-lightbox, .modal, .fade, .in, .show").modal('hide')
    @modal.modal('hide')
    placeholder = $(document).find("[data-behavior='image-invitation']")
    placeholder.attr "src", imagen_url
    $(document).find("[data-behavior='invitation-input']").val invitation_id
    console.log("InvitationID after close image: #{invitation_id}")

jQuery ->
  console.log("QuoationPrinting file is loaded....")
  $.map $("[data-behavior='quotation-printing']"), (item) ->
    console.log("Iterating QuotationPrinting")
    new QuotationPrinting(item)