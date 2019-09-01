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
    @selectNumberFolio.on "select2:select", @handleNumberFolioChange
    @buttonRegister.removeClass "disabled"

  handleNumberFolioChange: (e) =>
    text = "Nueva Cotización"
    option = e.params.data.text;
    if option == text
      @buttonRegister.text 'Registrar'
    else
      @buttonRegister.text 'Buscar'


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
    @item.find("[data-behavior='add_history']").on "click", @handleHistory

    @form = @wrapperForm.find("[data-behavior='form']")
    @form.on "submit", @handleValidateForm
    @form.on "keypress", @handleNoSendForm

    @wrapperForm.find("[data-behavior='category-invitation']").on "change", @handleChangeCategoryInvitation

    Utils.setDatePicker()
    Utils.inputsMask({rightAlign: false})
    Utils.collapsible()
    Utils.setScroll(@item.find("[data-behavior='chat_history']"))

  handleOpenCarousel: (e) =>
    @type = $(e.currentTarget).data("carousel-type")
    console.log("In HandleOpenCarousel")
    console.log("Type: #{@type}")

    if @type == 'printing-products'
      @handleOpenCarouselPrintingProducts(e)
    else
      @handleOpenCarouselInvitations(e)

  handleOpenCarouselInvitations: (e) =>
    #type = $(e.currentTarget).data("carousel-type")

    if @type == "invitations"
      category = @wrapperForm.find("[data-behavior='category-invitation']")
      category_id = category.find("option:selected").val()

    if @type == "contents"
      category = @wrapperForm.find("[data-behavior='category-content']")
      category_id = category.find("option:selected").val()

    if category_id
      $.ajax
        url: "/quotation_printings/data_carousel?category_id=#{category_id}&type=#{@type}"
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
    @handleBackgroundImage(modalBody)
    @carousel = new Carousel(@type)

  handleValidateForm: =>
    invitation = @wrapperForm.find("[data-behavior='invitation-input']")
    content_for_invitation = @wrapperForm.find("[data-behavior='content-for-invitation-input']")
    console.log("Validate Form: #{invitation.val()} => #{content_for_invitation.val()}")
    unless invitation.val() && content_for_invitation.val()
      toastr['error']('Proporcione los datos correctos');
      return false

  handleNoSendForm: (e) =>
    if e.keyCode == 13
      e.preventDefault()

  handleHistory: (e) =>
    input = @item.find("[data-behavior='message_history']")
    message = input.val()
    url = input.data("url")
    if message
      $.ajax(
        url: url
        method: "post"
        dataType: "json"
        data:
          message: message
        success: @handleHistorySuccess
      )


  handleChangeCategoryInvitation: (e) =>
    category = $(e.currentTarget).find("option:selected").text()
    label = @wrapperForm.find("[data-behavior='category-invitation-label']")
    label.text category

  handleBackgroundImage: (modalBody) =>
    fileBackgroundImage = modalBody.find("[data-behavior='file-background-image']")
    fileBackgroundImage.on "change", @handleChangeBackgroundImage
    @showBackgroundImage(modalBody)

  handleChangeBackgroundImage: (e) =>
    modal = @item.find("[data-behavior='modal']")
    modalBody = modal.find("[data-behavior='modal-body']")
    formBackground = modalBody.find("[data-behavior='form-background-image']")

    formBackground.parents("form")
      .on("ajax:success", (event) =>
        [data, status, xhr] = event.detail
        @setBackgroundImage(modalBody, data.url)
      ).on "ajax:error", (event) ->
        console.log("ERROR")

    formBackground.click()

  showBackgroundImage: (modalBody) =>
    backgroundURL = modalBody.find("[data-behavior='background-image']")
    urlImageBackground = backgroundURL.data("url")
    modalBody
      .css("background-image", "url(#{urlImageBackground})")
      .css("background-size", "cover")
      .animate({opacity: 1},{duration:1000});

  setBackgroundImage: (modalBody, url) =>
    backgroundURL = modalBody.find("[data-behavior='background-image']")
    urlImageBackground = backgroundURL.data("url", url)
    @showBackgroundImage(modalBody)

  handleHistorySuccess: (data) =>
    wrapper_messages = @item.find("[data-behavior='wrapper_history']")
    input = @item.find("[data-behavior='message_history']")

    wrapper_messages.append(data.result)
    input.val("")
    Utils.setScroll(@item.find("[data-behavior='chat_history']"))

class Carousel
  constructor: (type) ->
    console.log("Carousel created")
    @modal = $("[data-behavior='modal']")
    @modalBody = @modal.find("[data-behavior='modal-body']")
    @type = type
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
      showArrows: false,
#alwaysShowClose: true
      onContentLoaded: (e) =>
        @setClicImage()
        @handleZoomEvent()
        @setDataDescription()
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

    if type = 'printing_products'
      product_type = $(e.target).data("product-type")
      placeholder = $(document).find("[data-behavior='image-product-type-#{product_type}']")
      placeholder.attr "src", imagen_url
      printing_product_id = $(e.target).data("printing-product-id")
      $(document).find("[data-behavior='printing-product-input-#{product_type}']").val printing_product_id
      console.log("InvitationID after close image: #{invitation_id}")

  handleZoomEvent: =>
    console.log("Handle Zoom Event")
    element = $(".ekko-lightbox-item.fade.in.show > img")
    element.mlens({
        imgSrc: $(element).attr("src"),
        lensShape: "circle",
        lensSize: 250,
        borderSize: 4,
        borderColor: "#fff",
        borderRadius: 0,
        overlayAdapt: true
    })

    if @type == 'printing-products'
      element.parent().css("width", 'auto')

    else
      modal = $(".ekko-lightbox.modal.fade.in.show").find("div.modal-dialog")
      modal.css("max-width", "1150px")
      $(".ekko-lightbox-item.fade.in.show").css("width", "100%")
      mlensWrapper = $(".ekko-lightbox-item.fade.in.show")
        .find(">:first-child")
        .css("width", "auto")
        .css("overflow", "scroll")
        .css("max-height", "550px")

      mlensWrapper
        .find("img")
        .css("height", "auto")

  setDataDescription: =>
    if @type == 'printing-products'
      imageWrapper = $("[data-behavior='lightbox-image-wrapper']")
      imageWrapper.removeClass("col-sm-8").addClass("col-sm-12")
      element = $(".ekko-lightbox-item.fade.in.show > img")
      descriptionWrapper = $("[data-behavior='lightbox-description-wrapper']")
      descriptionWrapper.remove("col-sm-4").addClass("hidden")

    else
      title = $("[data-invitation-name]").data("invitation-name")
      category = $("[data-category-name]").data("category-name")
      subcategory = $("[data-subcategory-name]").data("subcategory-name")
      $("[data-behavior='product-modal']").text(title)
      $("[data-behavior='category-modal']").html("#{category} <br>#{subcategory}")


jQuery ->
  console.log("QuoationPrinting file is loaded....")
  $.map $("[data-behavior='quotation-printing']"), (item) ->
    console.log("Iterating QuotationPrinting")
    new QuotationPrinting(item)