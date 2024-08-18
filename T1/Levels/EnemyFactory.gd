extends Node

class_name EnemyFactory

var level: GenericT1Level

# Called when the node enters the scene tree for the first time.
func _ready():
	var spawn_timer = Timer.new()
	spawn_timer.set_wait_time(0.5)  # Spawn every 2 seconds
	spawn_timer.set_one_shot(false)  # Repeat
	spawn_timer.connect("timeout", create_enemy)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@export var enemy_scene = preload("res://T1/Enemies/BasicEnemy.tscn") # The generic enemy scene
@export var geometro_scene = preload("res://T1/Enemies/geometro_enemy.tscn")
@export var slime_scene = preload("res://T1/Enemies/slime_enemy.tscn")

#@export var sprite_directory: String = "res://sprites/enemies/" # Directory where enemy sprites are stored

# Function to create an enemy
func create_enemy():
	# Instantiate the generic enemy scene
	var x = randi_range(0,2)
	var enemy_instance = 0
	if x == 0:
		enemy_instance = slime_scene.instantiate()
	elif x == 1:
		enemy_instance = enemy_scene.instantiate()
	else:
		enemy_instance = geometro_scene.instantiate()
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
	var enemy = enemy_instance.find_child("GenericEnemy")
	#if enemy:
		#enemy.level = level
		#level.add_enemy(enemy)
	get_parent().add_child(enemy_instance)
	#get_tree().create
	return enemy_instance
