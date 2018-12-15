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
//= require rails-ujs
//= require bower_components/jquery-ui/jquery-ui.min.js
//= require bower_components/raphael/raphael.min.js
//= require plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js

//= require dist/js/adminlte.min.js
//= require plugins/iCheck/icheck.min.js

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
