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
    Utils.inputsMask({rightAlign: false})
    Utils.collapsible()

  handleOpenCarousel: (e) =>
    type = $(e.currentTarget).data("carousel-type")
    console.log("In HandleOpenCarousel")
    console.log("Type: #{type}")

    if type == 'printing-products'
      @handleOpenCarouselPrintingProducts(e)
    else
      @handleOpenCarouselInvitations(e)

  handleOpenCarouselInvitations: (e) =>
    type = $(e.currentTarget).data("carousel-type")

    if type == "invitations"
      category = @wrapperForm.find("[data-behavior='category-invitation']")
      category_id = category.find("option:selected").val()

    if type == "contents"
      category = @wrapperForm.find("[data-behavior='category-content']")
      category_id = category.find("option:selected").val()

    if category_id
      $.ajax
        url: "/quotation_printings/data_carousel?category_id=#{category_id}&type=#{type}"
        method: "get"
        dataType: "json"
        beforeSend: (xhr) ->
          $("body").LoadingOverlay("show")
        success: @showModal
        complete: (xhr) ->
          $("body").LoadingOverlay("hide", true)

  handleOpenCarouselPrintingProducts: (e) =>
    product_type = $(e.currentTarget).data("product-type")

    $.ajax
      url: "/printing_products/data_carousel?product_type=#{product_type}"
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
    type = $(e.target).data("type")

    if subcategory_id
      $.ajax
        url: "/quotation_printings/data_carousel?subcategory_id=#{subcategory_id}&type=#{type}"
        method: "get"
        dataType: "json"
        beforeSend: (xhr) ->
          $("body").LoadingOverlay("show")
        success: @handleSubcategoryChangeSuccess
        complete: (xhr) ->
          $("body").LoadingOverlay("hide", true)

  handleSubcategoryChangeSuccess: (response) =>
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
    imagen_url = $(e.target).data("image-url")
    type = $(e.target).data("type")
    $(".ekko-lightbox, .modal, .fade, .in, .show").modal('hide')
    @modal.modal('hide')

    if type == 'invitations'
      placeholder = $(document).find("[data-behavior='image-invitation']")
      placeholder.attr "src", imagen_url
      invitation_id = $(e.target).data("invitation-id")
      $(document).find("[data-behavior='invitation-input']").val invitation_id
      console.log("InvitationID after close image: #{invitation_id}")

    if type == 'contents'
      placeholder = $(document).find("[data-behavior='image-content']")
      placeholder.attr "src", imagen_url
      content_for_invitation_id = $(e.target).data("content-for-invitation-id")
      $(document).find("[data-behavior='content-for-invitation-input']").val content_for_invitation_id
      console.log("InvitationID after close image: #{invitation_id}")

jQuery ->
  console.log("QuoationPrinting file is loaded....")
  $.map $("[data-behavior='quotation-printing']"), (item) ->
    console.log("Iterating QuotationPrinting")
    new QuotationPrinting(item)