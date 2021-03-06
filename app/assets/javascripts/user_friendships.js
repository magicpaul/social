$(document).ready(function(){
	$('#add_friendship').click(function(event){
		event.preventDefault();
		var addFriendshipButton = $(this);
		$.ajax({
			url: Routes.user_friendships_path(
				{
					user_friendship: {friend_id: addFriendshipButton.data('friendId')}
				}),
			dataType: 'json',
			type: 'POST',
			success: function(e){
				addFriendshipButton.hide();
				$('#friend_status').html("<a href='#' class='tiny success round disabled button'>Friendship Requested</a>");
			}
		});

	});
});