# CentralController.gd
extends Control

@onready var menu = $"../Control2/TurretMenu"
#@onready var level = $"../Control/Level001"
@onready var level_manager = $"../../"
var selected_turret_type : String = ""
var turret_instance : Node2D = null
var level_rect : Rect2
var current_level: Node = null
var current_level_int: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.connect("turret_selected", Callable(self, "_on_turret_selected"))
	load_level(001)
	level_rect = Rect2(Vector2(0,0), Vector2(1024,1024))


func load_level(level_number: int):
	print("Loading level", level_number)
	current_level_int = level_number

	print("Loading level", level_number)
	if current_level:
		current_level.queue_free()
	
	var level_scene = load("res://T1/Levels/Level%03d.tscn" % level_number)
	if true:
		current_level = LevelGenerator.create_level(LevelGenerator.LEVELS[(level_number-1)%LevelGenerator.LEVELS.size()])
		%LevelContainer.add_child(current_level)
	elif level_scene:
		print("Loading level ", level_number)
		current_level = level_scene.instantiate()
		#current_level.add_child(LevelGenerator.create_level())
		%LevelContainer.add_child(current_level)
		level_rect = Rect2(Vector2(0,0), Vector2(1024,1024))
		#setup_level_rect()
	else:
		print("Failed to load level %d" % level_number)


	
#func setup_level_rect():
	## Wait for the level to be loaded
	#await get_tree().create_timer(0.1).timeout
	#var level = current_level
	#if level:
		#var background = level.get_node("Background")  # Adjust this path as needed
		#if background and background.texture:
			#var texture_size = background.texture.get_size() * background.global_scale
			#var level_position = background.global_position - (texture_size / 2)
			#level_rect = Rect2(level_position, texture_size)
		#else:
			#print("Background or texture not found!")
	
	
	#var background = level.get_child(0) as Sprite2D

	#if background and background.texture:
		#var texture_size = background.texture.get_size() * background.global_scale
		#var level_position = background.global_position - (texture_size / 2)

		## Calculate and cache the level's boundary rectangle
		#level_rect = Rect2(level_position, texture_size)
	#else:
		#print("Background or texture not found!")


func _on_turret_selected(turret_type):
	print("Turret selected", turret_type)
	selected_turret_type = turret_type
	create_turret_preview()


func create_turret_preview():
	if turret_instance:
		turret_instance.queue_free()
	turret_instance = load("res://T1/Turrets/" + selected_turret_type + ".tscn").instantiate()
	get_tree().get_first_node_in_group("level").add_child(turret_instance)
	turret_instance.visible = true
	turret_instance.z_index = 100  # Ensure it is on top
	
		# Create range indicator
	var range_indicator = create_range_indicator(turret_instance.turret_data.range/4)
	turret_instance.add_child(range_indicator)
	
	set_process(true)  # Ensure _process() is called to update the position


func create_range_indicator(range_value):
	var indicator = Node2D.new()
	indicator.z_index = 99  # Just below the turret
	indicator.name = "RangeIndicator"
	
	var circle = DrawingNode.new()
	circle.set_script(load("res://RangeCircle.gd"))
	print("Range!", range_value)
	circle.radius = range_value
	circle.color = Color(1, 1, 1, 0.2)  # Semi-transparent white
	
	indicator.add_child(circle)
	return indicator

# Function to show range of a placed turret
func show_turret_range(turret):
	var range_indicator = turret.get_node_or_null("RangeIndicator")
	if range_indicator:
		range_indicator.visible = true

# Function to hide range of a placed turret
func hide_turret_range(turret):
	var range_indicator = turret.get_node_or_null("RangeIndicator")
	if range_indicator:
		range_indicator.visible = false

# This is a custom DrawingNode class to draw the circle
class DrawingNode:
	extends Node2D
	
	var radius = 50
	var color = Color(1, 1, 1, 0.2)
	
	func _draw():
		draw_circle(Vector2.ZERO, radius, color)

func _on_level_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			place_turret()


func place_turret():
	if turret_instance:
		# Get the background node (assumed to be the first child of level)
		#var background = level.get_child(0) as Sprite2D
		#
		#if background and background.texture:
			#var texture_size = background.texture.get_size() * background.global_scale
			#var level_position = background.global_position - (texture_size / 2)			
			#var level_size = background.texture.get_size() * background.global_scale  # Consider scale
			## Calculate the level's boundary rectangle
			#var level_rect = Rect2(level_position, level_size)

			# Check if the turret's position is within the level's bounds
		var turret_pos = turret_instance.global_position
		if level_rect.has_point(turret_pos) and turret_instance.get_overlapping_areas().size() == 0:
			#turret_instance.reparent(level)
			turret_instance.real_tower = true
			turret_instance.z_index = 0
			turret_instance.global_position = turret_pos.round()  # Optional: snap to grid
			hide_turret_range(turret_instance)
			Globals.money -= turret_instance.turret_data.cost
			if Globals.money > 1000*current_level_int:
				load_level(current_level_int + 1)
			turret_instance = null  # Clear the instance after placement
		else:
			print("Invalid placement location!")
		#else:
			#print("Background or texture not found!")

func level_int_to_zeros(level_num):
	level_num

func valid_location(turret_instance):
	return level_rect.has_point(turret_instance.global_position) and turret_instance.get_overlapping_areas().size() == 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if turret_instance:
		turret_instance.global_position = get_global_mouse_position()
		
		if valid_location(turret_instance):
			turret_instance.modulate = Color(1, 1, 1, 1)  # Normal appearance (valid placement)
		else:
			turret_instance.modulate = Color(1, 0, 0, 0.5)  # Red and semi-transparent (invalid placement)
