extends GenericTurret

var frame_map = [0,1,2,3,4,5,6]
var projectile_frame = load("res://assets/T1/Turrets/RainbowLens/RainbowLensProjectile.png")
static var projectile = preload("res://T1/Turrets/rainbow_lens_projectile.tscn")

func _ready():
	scale = Vector2(2, 2)
	name = "RainbowLensTurret"
	super._ready()
	turret_data = Globals.RAINBOW_LENS_STATS

func _process(delta):
	super._process(delta)
	#var animate_progress = (turret_data.cooldown - cooldown) / turret_data.cooldown
	#var frame = min(frame_map.size() - 1, round(frame_map.size()*animate_progress))
	#$AnimatedSprite2D.frame = frame_map[frame]


func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	add_child(p)
	p.setup(self, target)	
	target.apply_damage(turret_data.damage)
	super.fire_at_target(target)



	
