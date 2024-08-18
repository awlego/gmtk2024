extends GenericTurret

var projectile = preload("res://T1/Turrets/PulseAttack.tscn")
var frame_map = [6,5,4,3,2,1,0,8,7]


# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	p.speed = 700
	p.direction = global_position.direction_to(target.global_position)
	p.rotation = p.direction.angle() + PI/2
	p.duration = 0.75
	p.scale = Vector2(1,1) * 0.25
	p.scale_rate = 1
	p.damage = turret_data.damage
	add_child(p)
	super.fire_at_target(target)

func _ready():
	super._ready()
	turret_data.range = 500
	turret_data.damage = 10
	cooldown = turret_data.cooldown * .8

func _process(delta):
	super._process(delta)
	var animate_progress = cooldown / turret_data.cooldown
	var frame = min(frame_map.size() - 1, round(frame_map.size()*animate_progress))
	%TurretSprite.frame = frame_map[frame]
