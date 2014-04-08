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

window.loadedActivities = [];
var addActivity = function(item){
    var found = false;
    for (var i = 0; i < window.loadedActivities.length;  i++) {
        if(window.loadedActivities[i].id == item.id){
            found=true;
        }
    }
    if (!found) {
        window.loadedActivities.push(item);
        window.loadedActivities.sort(function (a,b) {
            var returnValue;
            if (a.created_at > b.created_at)
                returnValue = -1;
            if (b.created_at > a.created_at)
                returnValue = 1;
            if (a.created_at == b.created_at)
                returnValue = 0;
        });
    }

    return item;

}
var renderActivities = function(){
    if (window.loadedActivities.length > 0) {
        var source = $('#activities-template').html();
        var template = Handlebars.compile(source);
        var html = template({
            activities: window.loadedActivities,
        });
        var $activityFeedLink = $('#drop2');
        $activityFeedLink.empty();
        $activityFeedLink.html(html);
        renderCount();
    }
    else{
        renderNoActivities();
    };

}
Array.prototype.removeValue = function(name, value){
   var array = $.map(this, function(v,i){
      return v[name] === value ? null : v;
   });
   this.length = 0;
   this.push.apply(this, array);
   renderActivities();
}
var renderNoCount = function() {
    $('#count').fadeOut();
}
var renderCount = function(){
    var source = $('#count-template').html();
    var template = Handlebars.compile(source);
    var count = window.loadedActivities.length;
    var html = template({
        count: window.loadedActivities.length
    });
    var $countBlock = $('#count');
    $countBlock.empty();
    if (count > 0) {
        $countBlock.fadeIn();
        $countBlock.html(html);
    }
    else{
        $countBlock.fadeOut();
    }
}
var renderNoActivities = function(){
    var source   = $("#no-activities-template").html();
    var template = Handlebars.compile(source);
    var html = template();
    var $activityFeedLink = $('#drop2');
    $activityFeedLink.empty();
    $activityFeedLink.html(html);
    renderNoCount();
}
Handlebars.registerHelper('activityFeedLink', function(){
    return new Handlebars.SafeString( Routes.activities_path() );
});
Handlebars.registerHelper('activityLink', function(){
    var link, path, html
    var activity = this;
    var linktext = activity.targetable_type.toLowerCase();
    var readPath = Routes.read_activity_path(activity)
    switch (linktext){
        case "status":
            path =  Routes.status_path(activity.targetable_id);
            break;
        case "userfriendship":
            path =  Routes.profile_path(activity.profile_name);
            linktext = "friend";
            break;
    }
    if (this.action == "earned"){
        linktext = "trophy";
    }
    html = "<div id='read-activity-menu-id-"+activity.id+"' class='notify-block'><img src="+this.avatar+" alt="+this.user_name+"><a href='"+path+"' class='action'>" + this.user_name + " " + this.action + " a " + linktext + ".</a><a href='"+ readPath +"'  class='remove-activity' data-remote='true' data-method='post'>&times;</a></div>";
    return new Handlebars.SafeString( html );
});
var pollActivity = function(){

    $.ajax({
        url: Routes.activities_path({format: 'json', since: window.lastFetch}),
        type: "GET",
        dataType: 'json',
        success: function(data){
            window.lastFetch = Math.floor((new Date).getTime()/1000);
            if (data.length > 0){
                for (var i = 0; i < data.length; i++) {
                    addActivity(data[i]);
                }
                renderActivities();
            }

        }
    });
}

window.pollInterval = window.setInterval(pollActivity, 5000);
pollActivity();

$(document).ajaxError(function(event, request) {
  var msg = request.getResponseHeader('X-Message');
  if (msg) alert(msg);
});