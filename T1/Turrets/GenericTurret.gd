extends Node2D

class_name GenericTurret

@export var turret_data: TurretResource
var level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	detect_enemies()

# Timer to manage firing rate
var fire_timer: Timer

# Targeted enemy
var current_target: GenericEnemy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	fire_timer = Timer.new()
	fire_timer.wait_time = 1.0 / turret_data.fire_rate
	fire_timer.one_shot = false
	add_child(fire_timer)
	fire_timer.connect("timeout", self._on_fire_timer_timeout)
	fire_timer.start()

# Detect enemies within range
func detect_enemies():
	var enemies = level.enemies.keys()
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= turret_data.range:
			current_target = enemy
			return
	current_target = null

# Fire at the target
func _on_fire_timer_timeout():
	if current_target:
		fire_at_target(current_target)

# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	pass
