class @Utils
  @inputsMask: (options) ->
    $.map $(document).find("[data-input-mask='currency-input']"), (item) ->
      $(item).inputmask("currency", options)

    $.map $(document).find("[data-input-mask='integer-input']"), (item) ->
      $(item).inputmask("integer", options);

  @setDatePicker: ->
    $.map $(document).find("[data-behavior='date']"), (item) ->
      console.log("Put datepicker utils")
      $(item).datepicker(
        format: "dd/mm/yyyy"
        language: "es"
      )

  @readURL: (fileImagen, $imagen) ->
    console.log(fileImagen.files)
    console.log($imagen)
    if fileImagen.files && fileImagen.files[0]
      $imagen.removeClass('hidden')
      reader = new FileReader

      reader.onload = (e) ->
        $imagen.attr 'src', e.target.result

      reader.readAsDataURL fileImagen.files[0]

    else
      tmpSrcImagePath = fileImagen.val()
      console.log("File imagen path: #{tmpSrcImagePath}")
      if tmpSrcImagePath != '' && typeof tmpSrcImagePath isnt 'undefined'
        $imagen.removeClass('hidden')
        $imagen.attr 'src', "uploads/tmp/#{tmpSrcImagePath}"
        console.log("Utils imagen working")

  @clientsAutocomplete: ->
    $.map $(document).find("[data-behavior='clients-autocomplete']"), (item) ->
      $(item).select2({
        minimumInputLength: 1,
        ajax: {
          delay: 250,
          url: "/clients/autocomplete",
          dataType: 'json',
          cache: true
        },
        escapeMarkup: escapeMarkup,
        templateResult: formatRepoClient,
        templateSelection: formatRepoSelectionClient
      })