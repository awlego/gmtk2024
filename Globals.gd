extends Node

const ENEMY_LAYER = 0b00000000_00000000_00000000_00000001
const ATTACK_LAYER = 0b00000000_00000000_00000000_00000010
const TOWER_LAYER = 0b00000000_00000000_00000000_00000100
const PATH_LAYER = 0b00000000_00000000_00000000_000001000

const TOWER_MASK = TOWER_LAYER + PATH_LAYER

var money = 100

# Dictionary to store scenes (Levels)
var scenes = {
	"level1": "res://scenes/Level1.tscn",
	"level2": "res://scenes/Level2.tscn",
	"main_menu": "res://scenes/MainMenu.tscn"
}

# Current active scene reference
var current_scene: Node = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Function to switch scenes
func switch_scene(scene_name: String) -> void:
	if scenes.has(scene_name):
		# Get the path to the new scene
		var new_scene_path = scenes[scene_name]
		
		# Load the new scene
		var new_scene = load(new_scene_path).instantiate()
		
		if current_scene:
			# Remove the current scene from the scene tree
			current_scene.queue_free()
		
		# Add the new scene to the scene tree
		get_tree().root.add_child(new_scene)
		
		# Set the new scene as the current scene
		current_scene = new_scene
		
		# Optional: Set the new scene as the active one (useful for changing input focus, etc.)
		get_tree().current_scene = new_scene
		
	else:
		print("Scene not found: " + scene_name)

# Make the script globally accessible by adding it to the autoload list in Project Settings -> AutoLoad
