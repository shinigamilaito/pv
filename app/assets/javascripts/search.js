function bindSearchSales($element, remote_url) {
  $element.on("keyup", _.debounce(searchProduct, 800));

  function searchProduct() {
    var textSearch = $element.val().trim();

    if(textSearch === "") {
      //location.reload()
    } else {
      console.log(textSearch);
      $.ajax({
        dataType: "script",
        method: "get",
        url: remote_url,
        data: { search: textSearch },
        beforeSend: function(xhr) { setSpinner($element); },
        complete: function(xhr) {
          deleteSpinner($element);
          if(xhr.status === 200) {
            $element.val('');
          }
        }
      });
    }
  }
}

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
            data: { search: textSearch },
            beforeSend: function(xhr) { setSpinner($element); },
            complete: function(xhr) { deleteSpinner($element) }
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
