$(document).ready(function() {
  var pieces = 'Pieza';
  var metros = 'Metro';
  var set = 'Juego';

  $("#printing_product_purchase_price").inputmask("currency", { rightAlign: false });
  $("#printing_product_sale_price").inputmask("currency", { rightAlign: false });
  setInteger($("#printing_product_stock"));
  setInteger($("#printing_product_contains"));

  $saleUnit = $("#printing_product_sale_unit");
  $contains = $("#printing_product_contains");
  $containsUnit = $("#printing_product_contain_unit");
  $formGroupContains = $("#form-group-contains");

  checkTypeUnitSale();
  console.log("Dispara change evento")

  $saleUnit.change(checkTypeUnitSale);

  function checkTypeUnitSale() {
    var saleUnit = $saleUnit.val();
    console.log("Unidad: " + saleUnit);

    if(saleUnit == pieces || saleUnit == metros || saleUnit == set || saleUnit == '') {
      $formGroupContains.css('display', 'none');
      console.log("Ocultar contiene");
      $contains.removeAttr('required');
      $containsUnit.removeAttr('required');

    } else {
      $formGroupContains.css('display', 'block');
      console.log("Mostrar contiene");
      $contains.attr('required', true);
      $containsUnit.attr('required', true);
    }
  }
});
