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
    $('[data-upload]').click(function(){
        $('#upfile').click();
    });
});
