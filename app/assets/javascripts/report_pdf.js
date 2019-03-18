var titlePrint = ''

function closePrint() {
  document.body.removeChild(this.__container__);
}

function setPrint() {
  this.contentWindow.__container__ = this;
  this.contentWindow.onbeforeunload = closePrint;
  this.contentWindow.onafterprint = closePrint;
  this.contentWindow.focus(); // Required for IE
  if($elementPrintPDF != undefined) {
    $elementPrintPDF.html(titlePrint);
    titlePrint = ''
  }
  this.contentWindow.print();
}

function printPage(element, sURL) {
  if(element != null) {
    $elementPrintPDF = element;
    titlePrint = $elementPrintPDF.html();
    $elementPrintPDF.html("Generando...");
  } else {
    $elementPrintPDF = undefined;
    titlePrint = '';
  }
  var oHiddFrame = document.createElement("iframe");
  oHiddFrame.onload = setPrint;
  oHiddFrame.style.visibility = "hidden";
  oHiddFrame.style.position = "fixed";
  oHiddFrame.style.right = "0";
  oHiddFrame.style.bottom = "0";
  oHiddFrame.src = sURL;
  document.body.appendChild(oHiddFrame);
}
