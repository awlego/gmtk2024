extends Control


@onready var menu = $"../Control2/TurretMenu"
@onready var level = $"../Control/Level001"
var selected_turret_type : String = ""
var turret_instance : Node2D = null
var level_rect : Rect2

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.connect("turret_selected", Callable(self, "_on_turret_selected"))

	var background = level.get_child(0) as Sprite2D
	
	if background and background.texture:
		var texture_size = background.texture.get_size() * background.global_scale
		var level_position = background.global_position - (texture_size / 2)
		
		# Calculate and cache the level's boundary rectangle
		level_rect = Rect2(level_position, texture_size)
	else:
		print("Background or texture not found!")


func _on_turret_selected(turret_type):
	print("Turret selected", turret_type)
	selected_turret_type = turret_type
	create_turret_preview()


func create_turret_preview():
	if turret_instance:
		turret_instance.queue_free()
	turret_instance = load("res://T1/Turrets/" + selected_turret_type + ".tscn").instantiate()
	level.add_child(turret_instance)
	turret_instance.visible = true
	turret_instance.z_index = 100  # Ensure it is on top
	
		# Create range indicator
	var range_indicator = create_range_indicator(turret_instance.turret_data.range/4)
	turret_instance.add_child(range_indicator)
	
	set_process(true)  # Ensure _process() is called to update the position


func create_range_indicator(range_value):
	var indicator = Node2D.new()
	indicator.z_index = 99  # Just below the turret
	
	var circle = DrawingNode.new()
	circle.set_script(load("res://RangeCircle.gd"))
	print("Range!", range_value)
	circle.radius = range_value
	circle.color = Color(1, 1, 1, 0.2)  # Semi-transparent white
	
	indicator.add_child(circle)
	return indicator

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
		var background = level.get_child(0) as Sprite2D
		
		if background and background.texture:
			var texture_size = background.texture.get_size() * background.global_scale
			var level_position = background.global_position - (texture_size / 2)			
			var level_size = background.texture.get_size() * background.global_scale  # Consider scale
			# Calculate the level's boundary rectangle
			var level_rect = Rect2(level_position, level_size)

			# Check if the turret's position is within the level's bounds
			var turret_pos = turret_instance.global_position
			if level_rect.has_point(turret_pos) and turret_instance.get_overlapping_areas().size() == 0:
				#turret_instance.reparent(level)
				turret_instance.real_tower = true
				turret_instance.z_index = 0
				turret_instance.global_position = turret_pos.round()  # Optional: snap to grid
				turret_instance = null  # Clear the instance after placement
			else:
				print("Invalid placement location!")
		else:
			print("Background or texture not found!")

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
