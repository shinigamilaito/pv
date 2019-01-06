// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require bower_components/jquery/dist/jquery.min.js
//= require bower_components/bootstrap/dist/js/bootstrap.min.js
//= require plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js
//= require bower_components/select2/dist/js/select2.full.min.js
//= require rails-ujs
//= require bower_components/jquery-ui/jquery-ui.min.js
//= require bower_components/raphael/raphael.min.js

//= require dist/js/adminlte.min.js
//= require plugins/iCheck/icheck.min.js

//= require bower_components/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js
//= require bower_components/bootstrap-datepicker/dist/locales/bootstrap-datepicker.es.min.js

//= require plugins/input-mask/inputmask.js
//= require plugins/input-mask/inputmask.extensions.js
//= require plugins/input-mask/inputmask.numeric.extensions.js
//= require plugins/input-mask/jquery.inputmask.js

//= require lodash.js

//= require toastr

//= require clients
//= require spare_parts

// require dist/js/pages/dashboard.js
// require dist/js/demo.js



// require jquery.min
// require bootstrap.min
// require rails-ujs
// require turbolinks
// require jquery-ui
// require toastr
// require select2.min




(function($){
	$(document).on("turbolinks:load", function(event) {
		/*$.fn.select2.defaults.set('theme', 'bootstrap4');

		$('.autocomplete_clients').select2({
			minimumInputLength: 3,
			ajax: {
				delay: 250,
				url: "/clients/autocomplete",
    			dataType: 'json'
    			cache: true
			}
		});*/
	});
}(jQuery));

$(document).ready(function() {
	$('[data-load="true"]').click(function() {
		console.log("Show the spinner....");
		$.LoadingOverlay("show");
	});

	$("#new_support_link").on("ajax:before", function() {
		console.log("Before send.....");
		$.LoadingOverlay("show");
	});

	$("#new_support_link").on("ajax:complete", function(event) {
		console.log("Complete....");
		$.LoadingOverlay("hide", true);
	});

	$(function () {
		$('.textarea').wysihtml5();
    	$('.textarea_new_equipment_customer').wysihtml5();
  	});

	$('.autocomplete_clients').select2({
		minimumInputLength: 3,
		ajax: {
			delay: 250,
			url: "/clients/autocomplete",
			dataType: 'json',
			cache: true
		}
	});

	$('.autocomplete_equipments').select2({
		minimumInputLength: 3,
		ajax: {
			delay: 250,
			url: "/equipments/autocomplete",
			dataType: 'json',
			cache: true
		}
	});

	$('.autocomplete_brands').select2({
		minimumInputLength: 3,
		ajax: {
			delay: 250,
			url: "/brands/autocomplete",
			dataType: 'json',
			cache: true
		}
	});
});
