$(document).ready(function(){$("#add_friendship").click(function(e){e.preventDefault();var s=$(this);$.ajax({url:Routes.user_friendships_path({user_friendship:{friend_id:s.data("friendId")}}),dataType:"json",type:"POST",success:function(){s.hide(),$("#friend_status").html("<a href='#' class='tiny success round disabled button'>Friendship Requested</a>")}})})});