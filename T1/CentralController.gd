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
	selected_turret_type = turret_type
	create_turret_preview()


func create_turret_preview():
	if turret_instance:
		turret_instance.queue_free()
	turret_instance = load("res://T1/Turrets/" + selected_turret_type + ".tscn").instantiate()
	add_child(turret_instance)
	turret_instance.visible = true
	turret_instance.z_index = 100  # Ensure it is on top
	set_process(true)  # Ensure _process() is called to update the position


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
			var turret_pos = turret_instance.position
			if level_rect.has_point(turret_pos):
				level.add_child(turret_instance)
				turret_instance.position = turret_pos.round()  # Optional: snap to grid
				turret_instance = null  # Clear the instance after placement
			else:
				print("Invalid placement location!")
		else:
			print("Background or texture not found!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if turret_instance:
		var turret_pos = get_global_mouse_position()
		turret_instance.position = turret_pos
		
		if level_rect.has_point(turret_pos):
			turret_instance.modulate = Color(1, 1, 1, 1)  # Normal appearance (valid placement)
		else:
			turret_instance.modulate = Color(1, 0, 0, 0.5)  # Red and semi-transparent (invalid placement)
