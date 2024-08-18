extends Area2D

class_name GenericEnemy
# The enemy data resource that defines its properties
@export var enemy_data: EnemyResource
#var level: GenericT1Level
var health = 100


# Signal emitted when the enemy is defeated
signal defeated

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	health = enemy_data.health
	pass # Initialization code here

func done():
	remove_from_group("enemy")
	get_parent().queue_free()

# Function to apply damage to the enemy
func apply_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

# Function called when the enemy is defeated
func die():
	if enemy_data.currency == "money":
		Globals.money += enemy_data.reward
	emit_signal("defeated")
	#if level:
		#level.remove_enemy(self)
	print(Globals.money)
	done()

func end_of_path():
	#if level:
		#level.remove_enemy(self)
	done()
	
# Movement function (for a simple straight-line movement)
func move_towards(target_position: Vector2, delta: float):
	var direction = (target_position - position).normalized()
	position += direction * enemy_data.speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walk(delta)
	pass

func walk(delta):
	get_parent().progress += enemy_data.speed * delta
	if get_parent().progress_ratio == 1.0:
		end_of_path()
