$(function(){$(".new-status-box").focus(function(){$(this).addClass("open")}),$("#cancel").click(function(){return $(".new-status-box").removeClass("open").val(""),$("small.error").hide(),$(".input-box").removeClass("error"),!1})});