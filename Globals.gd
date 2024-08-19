extends Node

# Collision

const ENEMY_LAYER = 0b00000000_00000000_00000000_00000001
const ATTACK_LAYER = 0b00000000_00000000_00000000_00000010
const TOWER_LAYER = 0b00000000_00000000_00000000_00000100
const PATH_LAYER = 0b00000000_00000000_00000000_000001000

const TOWER_MASK = TOWER_LAYER + PATH_LAYER

# Z-Axis
const Z_TURRET = 90
const Z_ENEMY = 100
const Z_ATTACK = 110

# Tower Stats
# TurretResource(DAMAGE, COOLDOWN, RANGE, COST)
var BLOOD_STATS = TurretResource.new()
var PULSE_STATS = TurretResource.new()
var LIGHTNING_STATS = TurretResource.new()
var MAGIC_STATS = TurretResource.new()
func init_tower_stats():
	BLOOD_STATS.damage = 15
	BLOOD_STATS.cooldown = 0.5
	BLOOD_STATS.range = 300
	BLOOD_STATS.cost = 10
	
	PULSE_STATS.damage = 15
	PULSE_STATS.cooldown = 2
	PULSE_STATS.range = 400
	PULSE_STATS.cost = 15
	
	LIGHTNING_STATS.damage = 15
	LIGHTNING_STATS.cooldown = 2
	LIGHTNING_STATS.range = 250
	LIGHTNING_STATS.cost = 15
	
	MAGIC_STATS.damage = 5
	MAGIC_STATS.cooldown = 2
	MAGIC_STATS.range = 150
	MAGIC_STATS.cost = 15

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

func _init():
	init_tower_stats()
