extends Node

# Collision

const ENEMY_LAYER = 0b00000000_00000000_00000000_00000001
const ATTACK_LAYER = 0b00000000_00000000_00000000_00000010
const TOWER_LAYER = 0b00000000_00000000_00000000_00000100
const PATH_LAYER = 0b00000000_00000000_00000000_000001000

const TOWER_MASK = TOWER_LAYER + PATH_LAYER

# Tower Stats
# TurretResource(DAMAGE, COOLDOWN, RANGE, COST)
var BLOOD_STATS = TurretResource.new()
var PULSE_STATS = TurretResource.new()
var LIGHTNING_STATS = TurretResource.new()
func _init():
	BLOOD_STATS.damage = 15
	BLOOD_STATS.cooldown = 0.5
	BLOOD_STATS.range = 300
	BLOOD_STATS.cost = 10
	
	PULSE_STATS.damage = 10
	PULSE_STATS.cooldown = 1
	PULSE_STATS.range = 450
	PULSE_STATS.cost = 15
	
	LIGHTNING_STATS.damage = 15
	LIGHTNING_STATS.cooldown = 2
	LIGHTNING_STATS.range = 250
	LIGHTNING_STATS.cost = 15
	
	

var money = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
