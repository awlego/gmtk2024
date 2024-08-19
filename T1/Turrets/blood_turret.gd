extends GenericTurret
var projectile = preload("res://T1/Turrets/BloodProjectile.tscn")
var frame_map = [7,7,8,0,1,2,3,4,5,6]

# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	p.speed = 700
	p.damage = turret_data.damage
	p.target = target
	add_child(p)
	super.fire_at_target(target)

func _ready():
	super._ready()
	turret_data = Globals.BLOOD_STATS
	cooldown = turret_data.cooldown * .8

func _process(delta):
	super._process(delta)
	var animate_progress = (turret_data.cooldown - cooldown) / turret_data.cooldown
	var frame = min(frame_map.size() - 1, round(frame_map.size()*animate_progress))
	%BloodTurretSprite.frame = frame_map[frame]
