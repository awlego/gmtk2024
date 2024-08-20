extends Node

class_name EnemyFactory

var rate = 2.0
const max_rate = 10.0
var difficulty = 1.0
var timer = 0.5
var scale_amount = 0.1
var scale_cooldown = 3.0
var scaler_timer = 1.0
var wave = 0
var remaining_spawns : = {}
var infinite = false
#var level: GenericT1Level

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy factory")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not infinite:
		spawn_wave(delta)
	else:
		endless(delta)

func start_wave(n):
	wave = n
	remaining_spawns = WAVES[n-1]["enemies"].duplicate(true)
	timer = WAVES[n-1]["spawn"]
	
func spawn_wave(delta):
	if remaining_spawns.is_empty():
		return
	timer -= delta
	if timer < 0:
		var d = LevelGenerator.LEVEL_BUFF_RATES[get_level()-1]
		timer += WAVES[wave-1]["spawn"] / d
		var enemy_type = remaining_spawns.keys().pick_random()
		remaining_spawns[enemy_type] -= 1
		if remaining_spawns[enemy_type] == 0:
			remaining_spawns.erase(enemy_type)
		var enemy = create_enemy_of_type(enemy_type)
		enemy.get_child(0).health_mod = d
		enemy.get_child(0).speed_mod = d
		get_parent().add_child(enemy)
		
func get_level():
	return get_tree().get_first_node_in_group("central").current_level_int
	
func endless(delta):
	timer -= delta
	while timer < 0:
		delayed_create()
		timer += 1.0/rate
	scaler_timer -= delta
	if scaler_timer < 0:
		scaler_timer += scale_cooldown
		rate += scale_amount
		if rate > max_rate:
			difficulty += rate - max_rate
			rate = max_rate
	

@export var enemy_scene = preload("res://T1/Enemies/BasicEnemy.tscn") # The generic enemy scene
@export var geometro_scene = preload("res://T1/Enemies/geometro_enemy.tscn")
@export var slime_scene = preload("res://T1/Enemies/slime_enemy.tscn")
@export var ogre_scene = preload("res://T1/Enemies/ogre.tscn")

#@export var sprite_directory: String = "res://sprites/enemies/" # Directory where enemy sprites are stored

func delayed_create(min = 0, max = 4):
	var s = Timer.new()
	s.wait_time = randf_range(min, max)
	s.one_shot = true
	s.connect("timeout", create_enemy)
	s.autostart = true
	add_child(s)
	
# Function to create an enemy
func create_enemy():
	# Instantiate the generic enemy scene
	var x = randi_range(0,4)
	var enemy_instance = 0
	if x == 0:
		enemy_instance = slime_scene.instantiate()
	elif x == 1:
		enemy_instance = enemy_scene.instantiate()
	elif x == 2:
		enemy_instance = ogre_scene.instantiate()
	elif x == 3:
		enemy_instance = geometro_scene.instantiate()
	else:
		var e = PathFollow2D.new()
		e.loop = false
		var fae = Faerie.new()
		e.add_child(fae)
		enemy_instance = e
	
	if difficulty > 1:
		enemy_instance.get_child(0).speed_mod = min(10, 1.0 + difficulty / 100)
		enemy_instance.get_child(0).health_mod = difficulty
	#enemy_instance.position = position

	# Assign the enemy data
	#var enemy_script = enemy_instance as Enemy
	#enemy_script.enemy_data = enemy_data

	# Load the appropriate sprite based on the enemy name
   # var sprite_path = sprite_directory + enemy_data.name + ".png"
	#var sprite_texture = load(sprite_path)
	#if sprite_texture:
	#else:
	#    print("Warning: No sprite found for enemy: " + enemy_data.name)

	# Add the enemy to the scene tree
	#var enemy = enemy_instance.find_child("GenericEnemy")
	#if enemy:
		#enemy.level = level
		#level.add_enemy(enemy)
	get_parent().add_child(enemy_instance)
	#get_tree().create
	return enemy_instance

enum ENEMIES {
	OGRE,
	GEOMETRO,
	SLIME,
	FAE_BLUE,
	FAE_GREEN,
	FAE_YELLOW,
	FAE_RED,
	FAE_PURPLE,
	KAREN
}

const WAVES = [
	# 1
	{"spawn": 2, "enemies": {ENEMIES.SLIME: 20}},
	# 2
	{"spawn": 2, "enemies": {ENEMIES.SLIME: 15, ENEMIES.FAE_BLUE: 15}},
	# 3
	{"spawn": 1, "enemies": {ENEMIES.SLIME: 15, ENEMIES.FAE_BLUE: 10, ENEMIES.GEOMETRO: 10}},
	# 4
	{"spawn": 1, "enemies": {ENEMIES.SLIME: 5, ENEMIES.FAE_BLUE:10, ENEMIES.GEOMETRO: 15, ENEMIES.FAE_GREEN: 10}},
	# 5
	{"spawn": 0.5, "enemies": {ENEMIES.FAE_YELLOW: 20}},
	# 6
	{"spawn": 0.5, "enemies": {ENEMIES.FAE_GREEN: 5, ENEMIES.FAE_BLUE: 5, ENEMIES.FAE_YELLOW: 5, ENEMIES.FAE_RED: 5, ENEMIES.FAE_PURPLE: 5, ENEMIES.KAREN: 5}},
	# 7
	{"spawn": 0.5, "enemies": {ENEMIES.SLIME: 5, ENEMIES.GEOMETRO: 5, ENEMIES.FAE_RED: 10, ENEMIES.FAE_PURPLE: 10, ENEMIES.KAREN: 5}},
	# 8
	{"spawn": 0.5, "enemies": {ENEMIES.OGRE: 5, ENEMIES.FAE_YELLOW: 20}},
	# 9
	{"spawn": 0.8, "enemies": {ENEMIES.OGRE: 10, ENEMIES.FAE_PURPLE: 10}},
	# 10
	{"spawn": 0.5, "enemies": {ENEMIES.OGRE: 20, ENEMIES.FAE_PURPLE: 20, ENEMIES.KAREN: 20}}
]

func create_enemy_of_type(enemy_type : ENEMIES):
	match enemy_type:
		ENEMIES.OGRE:
			return ogre_scene.instantiate()
		ENEMIES.GEOMETRO:
			return geometro_scene.instantiate()
		ENEMIES.SLIME:
			return slime_scene.instantiate()
		ENEMIES.FAE_BLUE:
			return Faerie.make_faerie("Blue")
		ENEMIES.FAE_GREEN:
			return Faerie.make_faerie("Green")
		ENEMIES.FAE_YELLOW:
			return Faerie.make_faerie("Yellow")
		ENEMIES.FAE_RED:
			return Faerie.make_faerie("Red")
		ENEMIES.FAE_PURPLE:
			return Faerie.make_faerie("Purple")
		ENEMIES.KAREN:
			return Faerie.make_faerie("Karen")
			

