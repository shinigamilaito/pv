function setPercentage($element) {
  $element.inputmask("percentage", {
    "suffix": ""
  });
}

function setCurrency($element) {
  $element.inputmask("currency", {
    "prefix": ""
  });
}

function setDatePicker($element) {
  $element.datepicker({
    format: "dd/mm/yyyy",
    language: "es"
  });
}
