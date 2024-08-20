class_name GenericTurret

extends Area2D

@export var turret_data: TurretResource
var real_tower = false
#var level
	
var cooldown = 0
#TODO: Change detect enemies to use a range collision circle and signals instead

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#super._process(delta)
	if not is_instance_valid(current_target):
		current_target = null
	if current_target != null and global_position.distance_to(current_target.global_position) > turret_data.range:
		current_target = null
	if real_tower and current_target == null:
		detect_enemies()
	cooldown = max(cooldown - delta, 0)
	if cooldown == 0 and is_instance_valid(current_target):
		fire_at_target(current_target)

# Targeted enemy
var current_target: GenericEnemy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_layer = Globals.TOWER_LAYER
	collision_mask = Globals.TOWER_MASK
	var collisionNode = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	var circ = CircleShape2D.new()
	circ.radius = 7
	rect.size = Vector2(15, 15)
	collisionNode.shape = circ
	z_index = Globals.Z_TURRET
	add_child(collisionNode)

# Detect enemies within range
func detect_enemies():
	current_target = null
	for enemy in get_tree().get_first_node_in_group("level").enemies:
		if global_position.distance_to(enemy.global_position) <= turret_data.range:
			current_target = enemy
			return
	


# Fire at the target (to be overridden by child classes)
func fire_at_target(target: Area2D):
	cooldown = turret_data.cooldown

