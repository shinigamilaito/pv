$(document).ready(function() {
  $("#product_price").inputmask("currency", { rightAlign: false });
  setInteger($("#product_quantity"));
});
