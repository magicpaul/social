(function(){jQuery(function(){return $(".pagination").length?($(window).scroll(function(){var n;return n=$(".pagination .next_page").attr("href"),n&&$(window).scrollTop()>$(document).height()-$(window).height()-50?($(".pagination").text("Fetching more products..."),$.getScript(n)):void 0}),$(window).scroll()):void 0})}).call(this);