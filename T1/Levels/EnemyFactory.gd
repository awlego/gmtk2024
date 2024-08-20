extends Node

class_name EnemyFactory

var rate = 2.0
const max_rate = 10.0
var difficulty = 1.0
var timer = 0.5
var scale_amount = 0.1
var scale_cooldown = 3.0
var scaler_timer = 1.0
#var level: GenericT1Level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
