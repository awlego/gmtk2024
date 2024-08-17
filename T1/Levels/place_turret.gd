extends Node2D

var selected_turret = null
var turret_preview = null
var can_place = false

func _ready():
	print("HELLO I AM IN THE PLACE TURRET")
	%TurretMenu.turret_selected.connect(_on_turret_selected)


func _on_turret_selected(turret_type):
	selected_turret = load("res://T1/Turrets/" + turret_type + ".tscn").instantiate()
	turret_preview = selected_turret.duplicate()
	turret_preview.set_process(false)
	add_child(turret_preview)
	
	# Add a temporary range indicator
	var range_indicator = CircleShape2D.new()
	range_indicator.radius = turret_preview.range
	var range_indicator_node = CollisionShape2D.new()
	range_indicator_node.shape = range_indicator
	range_indicator_node.name = "RangeIndicator"
	turret_preview.add_child(range_indicator_node)

func _process(delta):
	if turret_preview:
		var mouse_pos = get_global_mouse_position()
		turret_preview.global_position = mouse_pos
		update_turret_preview(mouse_pos)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if can_place:
			place_turret()

func update_turret_preview(pos):
	# Check if the position is valid for placement
	can_place = check_valid_placement(pos)
	turret_preview.modulate = Color.GREEN if can_place else Color.RED

	# Update range visualization
	if turret_preview.has_node("RangeIndicator"):
		turret_preview.get_node("RangeIndicator").visible = true

func check_valid_placement(pos):
	# Implement your logic to check if the position is valid
	# This might involve checking if it's on a valid tile, not overlapping other turrets, etc.
	return true  # Placeholder

func place_turret():
	if selected_turret:
		var new_turret = selected_turret.duplicate()
		new_turret.global_position = turret_preview.global_position
		add_child(new_turret)
		
		# Remove the range indicator from the placed turret
		if new_turret.has_node("RangeIndicator"):
			new_turret.get_node("RangeIndicator").queue_free()
		
		turret_preview.queue_free()
		turret_preview = null
		selected_turret = null
