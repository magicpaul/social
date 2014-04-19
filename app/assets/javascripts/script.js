Foundation.set_namespace = function() {};
$(function(){
    $(document).foundation();
});
$(function(){
    var textfield = $("input#user_email");
    $('#form input[type="submit"]').click(function(e) {
        e.preventDefault();

        //little validation just to check username
        if (textfield.val() != "") {
            $("#output").removeClass('alert-box alert');
            $("#output").addClass("alert-box success animated fadeInUp").html("<div class='loaderbox'><div class='loader'></div></div><span style='display:inline-block;margin-left: 2.5rem;'>Signing you in...</span>");
            $("input").css({
            "height":"0",
            "padding":"0",
            "margin":"0",
            "opacity":"0"
            });
            $(".profile-card").css({
                "padding-bottom":"0",
                "min-height" : "0"
            });
            $
            $('[data-alert]').hide();
            $('#form').submit();
        } else {
            //remove success mesage replaced with error message
            $('[data-alert]').hide();
            $("#output").removeClass(' alert-box success');
            $("#output").addClass("alert-box alert animated fadeInUp").html("Please enter an email");
        }
        //console.log(textfield.val());

    });
});