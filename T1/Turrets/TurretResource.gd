extends Resource

class_name TurretResource

# Tower properties
@export var range: float = 5.0
@export var cooldown: float = 1.0
@export var damage: int = 10
@export var cost: int = 10

func _init(damage = 10, cooldown = 1, range = 250, cost = 10):
	damage = damage
	cooldown = cooldown
	range = range
	cost = cost
