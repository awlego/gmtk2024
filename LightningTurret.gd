extends GenericTurret

var frame_map = [0,1,2,3,4,5,6,7,8,9]
var targets = 5
var chain_distance = 250
var lightning = load("res://assets/T1/Turrets/Lightning/LightningTowerProjectile.gif")
const sprite_length = 64
var pacifist_hits = 0

# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	if draw_lightning_to_target(global_position + Vector2(0, -32), target, targets, turret_data.damage):
		pacifist_hits = 0
	else:
		pacifist_hits += 1
	super.fire_at_target(target)

func draw_lightning_segment(pos, rot, scale = 1):
	var node = Node2D.new()
	var sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = lightning
	sprite.animation = "gif"
	sprite.frame = randi_range(0, 16)
	sprite.z_index = Globals.Z_ATTACK - 1
	add_child(node)
	node.add_child(sprite)
	sprite.position = Vector2(8, 0)
	node.global_position = pos
	node.rotation = rot
	node.scale = scale * Vector2(1,1)
	sprite.play("gif")
	sprite.speed_scale = 10
	
	var timer = Timer.new()
	timer.connect("timeout", sprite.queue_free)
	timer.one_shot = true
	timer.wait_time = 0.25
	add_child(timer)
	timer.start()

	return pos + Vector2.RIGHT.rotated(rot) * sprite_length * scale


func draw_lightning_to_target(from_pos, target, chain, damage, hits = {}):
	if chain <= 0:
		return false
	var target_pos = target.global_position
	var lpos = from_pos
	var x = 50
	while(lpos.distance_to(target_pos) > (sprite_length + 1) and x > 0):
		x -= 1
		lpos = draw_lightning_segment(lpos, lpos.angle_to_point(target_pos) + (randf() - 0.5)) + Vector2(randi_range(-3, 3), randi_range(-3, 3))
	lpos = draw_lightning_segment(lpos, lpos.angle_to_point(target_pos), lpos.distance_to(target_pos) / sprite_length)
	var killed = target.apply_damage(target.health/10 + damage)
	Globals.turret_stats["Damage"]["Lightning"] += (target.health/10 + damage)
	hits[target] = true
	var next = find_enemy_near(lpos, chain_distance, hits)
	if next:
		return draw_lightning_to_target(lpos, next, chain-1, damage, hits) or killed
	return killed
	
func find_enemy_near(tpos, max_d, except):
	var found = 0
	var next = null
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy not in except and tpos.distance_to(enemy.global_position) < max_d:
			found += 1
			#if next == null:
				#next = enemy
			if (randi() % found) == 0:
				next = enemy
	return next
	
func _ready():
	super._ready()
	turret_data = Globals.LIGHTNING_STATS

func _process(delta):
	super._process(delta * (100.0 + pacifist_hits*3) / 100.0)
	var animate_progress = (turret_data.cooldown - cooldown) / turret_data.cooldown
	var frame = min(frame_map.size() - 1, round(frame_map.size()*animate_progress))
	%TurretSprite.frame = frame_map[frame]
