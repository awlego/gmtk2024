extends Control

signal turret_selected(turret_type)


# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $VBoxContainer.get_children():
		button.pressed.connect(_on_tower_button_pressed.bind(button.name))

func _on_tower_button_pressed(tower_type):
	turret_selected.emit(tower_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass






