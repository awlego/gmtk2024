extends GenericTurret
var projectile = preload("res://T1/Turrets/heart_projectile.tscn")

# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	p.speed = 1000
	p.damage = turret_data.damage
	p.target = target
	add_child(p)
	pass
