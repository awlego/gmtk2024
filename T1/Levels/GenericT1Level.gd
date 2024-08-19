extends Node2D

class_name GenericT1Level

@export var level_data: T1LevelResource
var enemies = {}
# Called when the node enters the scene tree for the first time.

func add_enemy(enemy):
	enemies[enemy] = true

func remove_enemy(enemy):
	enemies.erase(enemy)
	
func register_factory():
	%EnemyFactory.level = self
	
func _ready():
	scale = Vector2(2, 2)
	add_to_group("level")
	#register_factory()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var central_controller = get_node("../../CentralController")
			if central_controller:
				var new_turret = null
				central_controller.place_turret()
				if event.shift_pressed and central_controller.turret_instance == null:
					central_controller.create_turret_preview()
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var central_controller = get_node("../../CentralController")
			if central_controller:
				if central_controller.turret_instance:
					central_controller.turret_instance.queue_free()
					central_controller.turret_instance = null
			

