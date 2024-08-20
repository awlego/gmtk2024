# PauseMenu.gd
# Godot4
extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # make sure the escape menu runs while game is paused
	$VBoxContainer/LeaderboardUILocal.score_filter = Leaderboards.ScoreFilter.NEARBY
	#main_menu_button.process_mode = Node.PROCESS_MODE_ALWAYS
	#main_menu_button.connect("pressed", Callable(self, "_on_main_menu_button_pressed"))
	$VBoxContainer/LeaderboardUILocal.prev_button.visible = false
	$VBoxContainer/LeaderboardUILocal.next_button.visible = false
	$VBoxContainer/LeaderboardUITop.prev_button.visible = false
	$VBoxContainer/LeaderboardUITop.next_button.visible = false
	#await $VBoxContainer/LeaderboardUILocal.refresh_scores()
	#await $VBoxContainer/LeaderboardUITop.refresh_scores()
	#pause_game() # I don't actually wanna pause the game cause it causes bugs when also running leaderboards

func _exit_tree():
	unpause_game()

func pause_game():
	get_tree().paused = true

func unpause_game():
	get_tree().paused = false

func _on_main_menu_button_pressed():
	unpause_game()
	queue_free()
	
func _on_resume_button_pressed():
	unpause_game()
	queue_free()  # This will remove the escape menu from the scene

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):  # Usually the Escape key
		unpause_game()
		queue_free()  # Close the menu
