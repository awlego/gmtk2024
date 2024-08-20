extends GenericTurret
var projectile = preload("res://T1/Turrets/BloodProjectile.tscn")
var frame_map = [7,7,8,0,1,2,3,4,5,6]
var speed = 600
var speed_buff = 10
var damage
var damage_buff = 0.02
var rate = 1.0
var rate_buff = 0.02

# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	var p = projectile.instantiate()
	p.speed = speed
	p.damage = damage
	p.target = target
	add_child(p)
	super.fire_at_target(target)
	current_target = null

func _on_kill():
	rate += rate_buff
	damage += damage_buff
	speed += speed_buff

func _ready():
	super._ready()
	turret_data = Globals.BLOOD_STATS
	damage = turret_data.damage
	cooldown = turret_data.cooldown * .8

func _process(delta):
	super._process(delta * rate)
	var animate_progress = (turret_data.cooldown - cooldown) / turret_data.cooldown
	var frame = min(frame_map.size() - 1, round(frame_map.size()*animate_progress))
	%BloodTurretSprite.frame = frame_map[frame]

func detect_enemies():
	var n = 0
	for enemy in get_tree().get_first_node_in_group("level").enemies:
		if global_position.distance_to(enemy.global_position) <= turret_data.range:
			n+=1
			if (randi() % n) == 0:
				current_target = enemy
	
