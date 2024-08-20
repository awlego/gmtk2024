extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$LeaderboardUILocal.title_label.text = "Nearby Leaderboard"
	$LeaderboardUILocal.score_filter = Leaderboards.ScoreFilter.NEARBY
	$LeaderboardUILocal.score_filter = Leaderboards.ScoreFilter.NEARBY
	$LeaderboardUILocal.score_limit = 20
	$LeaderboardUILocal.prev_button.visible = false
	$LeaderboardUILocal.next_button.visible = false
	$LeaderboardUITop.prev_button.visible = false
	$LeaderboardUITop.next_button.visible = false
	$LeaderboardUITop.title_label.text = "Global Leaderboard"
	$LeaderboardUITop.score_limit = 20
	$LeaderboardUITop.nearby_count = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	
	pass # Replace with function body.
