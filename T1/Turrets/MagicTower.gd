extends GenericTurret
static var projectile = preload("res://T1/Turrets/magic_projectile.tscn")
const FRAMES = 10
const SHOOT_FRAME_READY = 9

# Called when the node enters the scene tree for the first time.
func _ready():
	turret_data = Globals.MAGIC_STATS
	#scale = Vector2(2,2)
	super()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.frame = int((min(FRAMES-1, (turret_data.cooldown - cooldown)/turret_data.cooldown * FRAMES) + SHOOT_FRAME_READY + 1)) % FRAMES
	super(delta)
	

func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	p.position += Vector2(-8,0)
	p.setup(target.global_position if target.global_position else Vector2(100,100), 6, .75, turret_data.damage)
	add_child(p)
	super(target)
