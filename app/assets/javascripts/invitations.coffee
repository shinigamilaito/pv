class InvitationForm
  constructor: (item) ->
    console.log("Invitaton Form created")
    @item = $(item)
    @setEvents()

  setEvents: ->
    console.log("Set Event change")
    @item.find("[data-behavior='category']").on "change", @handleToggle

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
    @item.find("[data-behavior='subcategories']").html(data.subcategories)


jQuery ->
  console.log("Invitations file is loaded....")
  $.map $("[data-behavior='invitation-form']"), (item) ->
    new InvitationForm(item)
