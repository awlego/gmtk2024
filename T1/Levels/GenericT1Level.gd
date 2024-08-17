extends Node2D

class_name GenericT1Level

@export var level_data: T1LevelResource
var enemies = {}
# Called when the node enters the scene tree for the first time.

func add_enemy(enemy):
	enemies[enemy] = true
	print("Made an enemy!")

func remove_enemy(enemy):
	enemies.erase(enemy)
	print("An enemy disappeared!")
	
func register_factory():
	%EnemyFactory.level = self
	
func _ready():
	register_factory()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
