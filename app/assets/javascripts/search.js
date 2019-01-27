function bindSearch($element, remote_url) {
    $element.keypress(function(e) {
      var textSearch = $(this).val().trim();

      if(enterKeyPressed(e)) {
        if(textSearch === "") {
          //location.reload()

        } else {
          $.ajax({
            dataType: "script",
            method: "get",
            url: remote_url,
            data: {
              search: textSearch
            },
            beforeSend: function(xhr) {
              $element.LoadingOverlay("show");
            },
            complete: function(xhr) {
              $element.LoadingOverlay("hide", true);
            }
          });
        }
      }
    });
}

function enterKeyPressed(e) {
  var keycode = (e.keyCode ? e.keyCode : e.which);
  if (keycode == '13') {
    return true;
  } else {
    return false;
  }
}
