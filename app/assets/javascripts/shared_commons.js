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

function setHTMLDescription($element) {
  $element.wysihtml5();
}

function setInteger($element) {
  $element.inputmask("integer", {
    rightAlign: false
  });
}

function setSpinner($element) {
  $element.LoadingOverlay("show");
}

function deleteSpinner($element) {
  $element.LoadingOverlay("hide", true);
}
