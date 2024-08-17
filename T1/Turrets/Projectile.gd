extends Node2D
class_name Projectile

var speed
var damage
var target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not (speed && damage && target && is_instance_valid(target)):
		queue_free()
		return
	var delta_pos = speed * delta
	if delta_pos >= global_position.distance_to(target.global_position):
		global_position = target.global_position
		target.apply_damage(damage)
		queue_free()
	else:
		global_position += global_position.direction_to(target.global_position) * delta_pos
	
	
