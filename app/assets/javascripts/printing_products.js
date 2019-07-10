$(document).ready(function() {
  $saleUnit = $("#printing_product_sale_unit");
  $contains = $("#printing_product_contains");
  $containsUnit = $("#printing_product_contain_unit");
  $formGroupContains = $("#form-group-contains");

  readURL($("#printing_product_imagen_cache"));

  $("#printing_product_imagen").change(function(){
    $('#img_prev').removeClass('hidden');
    readURL(this);
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    } else {
      console.log("URL PRINTING_PRODUCTS: " + input.val());
      if(input.val() != "" && input.val() != undefined) {
          $('#img_prev').removeClass('hidden');
          $('#img_prev').attr('src', "uploads/tmp/" + input.val());
      }
    }
  }
});
