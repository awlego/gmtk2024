extends Area2D

class_name GenericEnemy
# The enemy data resource that defines its properties
@export var enemy_data: EnemyResource
#var level: GenericT1Level
var health = 100
var speed_mod = 1.0
var slow = 1.0
var health_mod = 1.0
var slowed: bool = false

@onready var game_over_scene_path = "res://game_over.tscn"

# Signal emitted when the enemy is defeated
signal defeated

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	health = enemy_data.health * health_mod
	get_parent().loop = false
	z_index = Globals.Z_ENEMY
	pass # Initialization code here

func done():
	remove_from_group("enemy")
	get_parent().queue_free()

# Function to apply damage to the enemy
func apply_damage(amount: int) -> bool:
	health -= amount
	if health <= 0:
		die()
		return true
	return false

# Function called when the enemy is defeated
func die():
	if enemy_data.currency == "money":
		Globals.money += enemy_data.reward
	emit_signal("defeated")
	#if level:
		#level.remove_enemy(self)
	#print(Globals.money)
	Globals.update_bank_ui_ref.call(Globals.money)
	done()

func game_over():
	print("You Lost")
	get_tree().change_scene_to_file(game_over_scene_path)



func end_of_path():
	#if level:
		#level.remove_enemy(self)
	Globals.health -= enemy_data.damage
	Globals.health = clamp(Globals.health, 0, 100)
	Globals.update_health_ui_ref.call(Globals.health)
	if Globals.health == 0:
		game_over()
	#print("You now have ", Globals.money, "$")
	done()
	
# Movement function (for a simple straight-line movement)
func move_towards(target_position: Vector2, delta: float):
	var direction = (target_position - position).normalized()
	position += direction * enemy_data.speed * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walk(delta)
	if (slow < 1.0) != slowed:
		slowed = (slow < 1.0)
		apply_frost_effect(slowed)

func walk(delta):
	get_parent().progress += enemy_data.speed * delta * speed_mod * max(.2, slow)
	if get_parent().progress_ratio == 1.0:
		end_of_path()
		
		
func find_sprite():
	"""goes through the children of the enemy and looks for either a Sprite2D or AnimatedSprite2D
	then returns that node by reference"""
	for child in get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			return child
	return null
		
func apply_slow(slow_amount):
	slow *= slow_amount
	await get_tree().create_timer(1.8).timeout
	slow /= slow_amount

func apply_frost_effect(on = true):
	var frost_shader := ShaderMaterial.new()
	frost_shader.shader = load("res://shaders/chilled.gdshader")
	var sprite = find_sprite()
	sprite.material = frost_shader
	sprite.material.set_shader_parameter("enabled", on)
