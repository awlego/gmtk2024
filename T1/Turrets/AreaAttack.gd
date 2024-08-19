extends Area2D
class_name AreaAttack

var damage = 10
var enemies_hit = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	z_index = Globals.Z_ATTACK
	area_entered.connect(_on_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		if area not in enemies_hit:
			area.apply_damage(damage)
			enemies_hit[area] = 0
