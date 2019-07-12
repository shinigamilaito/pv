class @Utils
  @inputsMask: (options) ->
    $.map $(document).find("[data-input-mask='currency-input']"), (item) ->
      Utils.inputMaskCurrency(item, options)

    $.map $(document).find("[data-input-mask='integer-input']"), (item) ->
      Utils.inputMaskInteger(item, options)

  @inputMaskCurrency: (item, options) ->
    $(item).inputmask("currency", options)

  @inputMaskInteger: (item, options) ->
    $(item).inputmask("integer", options);

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