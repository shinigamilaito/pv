$(document).ready(function() {
  $("#spare_part_price_purchase").inputmask("currency", { rightAlign: false });
  $("#spare_part_price").inputmask("currency", { rightAlign: false });
  setInteger($("#spare_part_total"));
  setInteger($("#spare_part_stock_minimum"));  
});
