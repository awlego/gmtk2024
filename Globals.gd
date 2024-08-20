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
const Z_GUI = 200

# Tower Stats
# TurretResource(DAMAGE, COOLDOWN, RANGE, COST)
var BLOOD_STATS = TurretResource.new()
var PULSE_STATS = TurretResource.new()
var LIGHTNING_STATS = TurretResource.new()
var MAGIC_STATS = TurretResource.new()
var RAINBOW_LENS_STATS = TurretResource.new()
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
	
	RAINBOW_LENS_STATS.damage = 100
	RAINBOW_LENS_STATS.cooldown = 4
	RAINBOW_LENS_STATS.range = 500
	RAINBOW_LENS_STATS.cost = 30

var money = 100

# Dictionary to store scenes (Levels)
var scenes = {
	"level1": "res://scenes/Level1.tscn",
	"level2": "res://scenes/Level2.tscn",
	"level3": "res://scenes/Level3.tscn",
	"main_menu": "res://scenes/MainMenu.tscn"
}

var faeries = ["Blue", "Green", "Yellow", "Red", "Purple", "Karen"]

var faerie_sprites = {
}
func init_faerie_sprites():
	for c in faeries:
		faerie_sprites[c] = load("res://assets/T1/Enemies/Faerie_" + c + ".bmp")

var faerie_stats = {
	"Blue": EnemyResource.new(),
	"Green": EnemyResource.new(), 
	"Yellow": EnemyResource.new(), 
	"Red": EnemyResource.new(), 
	"Purple": EnemyResource.new(), 
	"Karen": EnemyResource.new()
}
func init_faerie_stats():
	faerie_stats["Blue"].name = "Blue Faerie"
	faerie_stats["Blue"].speed = 90
	faerie_stats["Blue"].health = 80
	faerie_stats["Blue"].damage = 5
	faerie_stats["Blue"].reward = 8
	
	faerie_stats["Green"].name = "Green Faerie"
	faerie_stats["Green"].speed = 110
	faerie_stats["Green"].health = 110
	faerie_stats["Green"].damage = 10
	faerie_stats["Green"].reward = 12
	
	faerie_stats["Yellow"].name = "Yellow Faerie"
	faerie_stats["Yellow"].speed = 200
	faerie_stats["Yellow"].health = 80
	faerie_stats["Yellow"].damage = 5
	faerie_stats["Yellow"].reward = 15
	
	faerie_stats["Red"].name = "Red Faerie"
	faerie_stats["Red"].speed = 100
	faerie_stats["Red"].health = 200
	faerie_stats["Red"].damage = 10
	faerie_stats["Red"].reward = 20
	
	faerie_stats["Purple"].name = "Purple Faerie"
	faerie_stats["Purple"].speed = 200
	faerie_stats["Purple"].health = 200
	faerie_stats["Purple"].damage = 20
	faerie_stats["Purple"].reward = 30
	
	faerie_stats["Karen"].name = "Karen"
	faerie_stats["Karen"].speed = 400
	faerie_stats["Karen"].health = 50
	faerie_stats["Karen"].damage = 10
	faerie_stats["Karen"].reward = 1

# Current active scene reference
var current_scene: Node = null

var update_bank_ui_ref = null

var leaderboard_id = "gmtk2024-awlego-turret-defense--MXL9"

var username: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	username = generate_username()
	pass # Replace with function body.


func generate_username() -> String:
	"""Makes a funny sounding username"""

	# Lists of funny syllables or words
	var prefixes = ["Fluffy", "Bumpy", "Wiggly", "Snooty", "Zippy", "Squishy"]
	var suffixes = ["Pants", "Noodle", "Sprout", "Muffin", "Bumble", "Doodle"]

	# Combine a random prefix, middle, and suffix
	var prefix = prefixes[randi() % prefixes.size()]
	var suffix = suffixes[randi() % suffixes.size()]

	# Combine them to form the username
	var username = prefix + suffix

	return username

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_level(level_number: int):
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	if level_manager:
		level_manager.load_level(level_number)
	else:
		print("Level manager not found!")

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
	init_faerie_stats()
	init_faerie_sprites()
