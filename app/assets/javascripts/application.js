// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require js-routes
//= require foundation
//= require_tree .

Foundation.set_namespace = function() {};
$(function(){ 
	
	$('#form').promin({
        'events': {
            'submit': function(fields) {
                var empty = false;

            fields.each(function( i, e ) {
                var $e = $( e );
                var val = $e.val();
                var length = val.length;

                empty = ( length === 0 );

                // sound the alarms, abort mission, we have an empty field!
                if( empty ) {
                    // show (first) invalid field and highlight
                    $( '#form' ).promin('show', i);
                    $e.addClass( 'error' );

                    return false;
                }
            });

            // if there are no empty fields, do submit
            return (!empty);
                $('.pm-step').hide();
                $('.message-submit').show();
                $('#description').hide();
            }
        }
    });
    $(document).foundation(); 
});
