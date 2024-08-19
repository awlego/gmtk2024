# LevelManager.gd
extends Node

var current_level: Node = null
var level_container: Control

#@onready var level_container = $LevelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	level_container = %LevelContainer
	if not level_container:
		push_error("LevelContainer not found!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func load_level(level_number: int):
	print("Loading level", level_number)
	if not level_container:
		print("Level container not inited")
		push_error("LevelContainer not initialized!")
		return
	print("Loading level", level_number)
	if current_level:
		current_level.queue_free()
	
	var level_scene = load("res://T1/Levels/Level%03d.tscn" % level_number)
	if level_scene:
		print("HELLO222")
		print("Loading level ", level_number)
		current_level = level_scene.instantiate()
		level_container.add_child(current_level)
		current_level.add_child(LevelGenerator.create_level())
	else:
		print("Failed to load level %d" % level_number)
