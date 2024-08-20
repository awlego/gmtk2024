extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	z_as_relative = false
	z_index = Globals.Z_GUI
	update_nametag(Globals.username)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_nametag(name: String) -> void:
	$NinePatchRect/CenterContainer/Label.text = name
