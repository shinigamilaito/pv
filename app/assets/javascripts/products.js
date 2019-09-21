$(document).ready(function() {
  $("#product_price_purchase").inputmask("currency", { rightAlign: false });
  $("#product_price").inputmask("currency", { rightAlign: false });
  setInteger($("#product_quantity"));
  setInteger($("#product_stock_minimum"));
});
