extends Node2D
var target_pos
var duration
var cooldown_max
var damage

var cooldown
var speed_y
var speed_x
var dir
var strobing = false

const G = 500
const TTH = 1
const FRAMES = 9

func setup(target_pos, duration, cooldown_max, damage):
	self.target_pos = target_pos
	self.duration = duration
	self.cooldown_max = cooldown_max
	self.damage = damage

func _ready():
	z_index = Globals.Z_ATTACK
	speed_x = target_pos.x - global_position.x
	speed_x *= TTH
	var diffy = target_pos.y - global_position.y
	# Y travel = G/2 * TTH^2 + TTH * speed_y = diffy
	# speed_y * TTH = diffy - G/2 * TTH^2
	speed_y = (diffy - G/2 * TTH * TTH) / TTH

func _process(delta):
	if strobing == false:
		if abs(speed_x * delta) > abs((global_position.x - target_pos.x)):
			start_hit(delta)
		else:
			process_move(delta)
	else:
		process_strobe(delta)

func process_move(delta):
	%Animation.frame = 1
	speed_y += G/2 * delta
	global_position.x += speed_x * delta
	global_position.y += speed_y * delta
	speed_y += G/2 * delta

func process_strobe(delta):
	duration -= delta
	cooldown += delta
	%Animation.frame = min(8, (FRAMES * cooldown / cooldown_max))
	if cooldown > cooldown_max:
		damage_enemies()
		cooldown = 0
	if duration < 0:
		queue_free()

func damage_enemies():
	for enemy in %AreaAttack.get_overlapping_areas():
		if is_instance_valid(enemy):
			enemy.apply_damage(damage)

func start_hit(delta):
	global_position = target_pos
	strobing = true
	cooldown = 0
	z_index = Globals.Z_ENEMY - 1
	process_strobe(delta)
