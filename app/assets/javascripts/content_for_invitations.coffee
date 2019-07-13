class ContentInvitationForm
  constructor: (item) ->
    console.log("ContentInvitationForm created")
    @$item = $(item)
    @initialize()
    @setEvents()

  initialize: ->
    @imageLoad()

  setEvents: ->
    @$item.find("[data-behavior='file-image']").on "change", @handleImage

    console.log("Set Event change")
    @$item.find("[data-behavior='category']").on "change", @handleToggle

  handleToggle: (e) =>
    console.log("Change category: #{$(e.target).find("option:selected").val()}")
    $option = $(e.target).find("option:selected")
    category_id = $option.val()

    $.ajax(
      url: "/categories/#{category_id}/subcategories"
      method: "get"
      dataType: "json"
      success: @handleToggleSuccess
    )

  handleToggleSuccess: (data) =>
    console.log("Data received: #{data}")
    @$item.find("[data-behavior='subcategories']").html(data.subcategories)
    @$item.find("#invitation_subcategory_id").attr("name", "content_for_invitation[subcategory_id]")

  imageLoad: ->
    @$fileImagenCache = @$item.find("[data-behavior='file-image-cache']")
    @$imagen = @$item.find("[data-behavior='imagen']")

    console.log("Calling Util.readURL from: imageLoad")
    Utils.readURL(@$fileImagenCache, @$imagen)

  handleImage: (event) =>
    console.log("Calling Util.readURL from: handleImage")
    Utils.readURL(event.target, @$imagen)


jQuery ->
  console.log("Content For Invitations file is loaded....")
  $.map $("[data-behavior='content-invitation-form']"), (item) ->
    new ContentInvitationForm(item)
