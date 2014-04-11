/*$(".likes-button a").click(function () {
    $(this).addClass('activated');
});*/
$(function() {
    $(".new-status-box").focus(function(){
        $(this).addClass('open');
    });

    $("#cancel").click(function(){
        $(".new-status-box").removeClass('open').val('');
        $('small.error').hide();
        $('.input-box').removeClass('error');
        return false;
    });
});
