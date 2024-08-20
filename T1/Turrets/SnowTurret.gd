extends GenericTurret

var projectile = preload("res://T1/Turrets/SnowAttack.tscn")
var frame_map = [6,5,4,3,2,1,0,8,7]


# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	p.speed = 700
	p.direction = global_position.direction_to(target.global_position)
	p.rotation = p.direction.angle() + PI/2
	p.duration = turret_data.range / p.speed * 1.15
	p.scale = Vector2(1,1) * 0.25
	p.scale_rate = 16
	p.damage = turret_data.damage
	add_child(p)
	super.fire_at_target(target)

func _ready():
	turret_data = Globals.SNOW_STATS
	super._ready()


func _process(delta):
	super._process(delta)
	var animate_progress = cooldown / turret_data.cooldown
	var frame = min(frame_map.size() - 1, round(frame_map.size()*animate_progress))
	%TurretSprite.frame = frame_map[frame]
