extends Node2D

class_name GenericT1Level

@export var level_data: T1LevelResource
var enemies = []
var life = 100
var wave = 0
var infinite = false
	
func _ready():
	level_announce()
	wave = 0
	scale = Vector2(2, 2)
	add_to_group("level")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	enemies = get_tree().get_nodes_in_group("enemy")
	enemies.sort_custom(func(e1, e2): return e1.get_parent().progress_ratio > e2.get_parent().progress_ratio)
	
	if not infinite and enemies.size() == 0:
		var wave_done = true
		for factory in get_tree().get_nodes_in_group("enemy factory"):
			if not factory.remaining_spawns.is_empty() or factory.wave != wave:
				wave_done = false
		if wave_done:
			wave += 1
			start_wave(wave)
			
	
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
			

func level_announce():
	var popup = load("res://T1/Levels/wave_announce.tscn").instantiate()
	popup.get_child(0).text = "Level " + str(get_level())
	var timer = Timer.new()
	timer.connect("timeout", popup.queue_free)
	timer.wait_time = 5
	timer.autostart = true
	timer.one_shot = true
	popup.add_child(timer)
	add_child(popup)
	popup.visible = true
	popup.position = Vector2(512,256) - popup.get_child(0).size / 2
	
	
func start_wave(n):
	if n > 5 * get_level():
		get_tree().get_first_node_in_group("central").next_level()
		return
	var popup = load("res://T1/Levels/wave_announce.tscn").instantiate()
	var text = popup.get_child(0)
	text.text = "Wave " + str(n)
	if n > EnemyFactory.WAVES.size():
		text.text = "Endless Mode"
	var timer = Timer.new()
	timer.connect("timeout", popup.queue_free)
	timer.wait_time = 5
	timer.autostart = true
	timer.one_shot = true
	popup.add_child(timer)
	add_child(popup)
	popup.visible = true
	popup.position = Vector2(512,512) - text.size / 2
	#popup.rect_global_position  = Vector2(250, 250)
	#print(popup)
	
	
	for factory in get_tree().get_nodes_in_group("enemy factory"):
		timer.connect("timeout", factory.start_wave.bind(n))
		#factory.start_wave(n)

func get_level():
	return get_tree().get_first_node_in_group("central").current_level_int
