extends Control

signal turret_selected(turret_type)
@onready var vbox_container = $VBoxContainer

# A list of dictionaries containing the turret type and corresponding sprite path
var starting_turrets = [
	{"type": "blood_turret", "sprite_path": "res://assets/T1/Turrets/Blood/BloodShooter.gif"},
	{"type": "PulseTurret", "sprite_path": "res://assets/T1/Turrets/Pulse/PulseTowerAttack.gif"},
	{"type": "LightningTurret", "sprite_path": "res://assets/T1/Turrets/Lightning/LightningTower.gif"},
	{"type": "MagicTower", "sprite_path": "res://assets/T1/Turrets/Magic/MagicTower.gif"},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	var label = Label.new()
	label.text = "Add Turret"
	$VBoxContainer.add_theme_constant_override("separation", 24)

	vbox_container.add_child(label)
	for turret in starting_turrets:
		create_turret_texture_button(turret)

func _on_tower_button_pressed(tower_type):
	turret_selected.emit(tower_type)

func _on_turret_button_pressed(tower_type):
	turret_selected.emit(tower_type)

func unlock_new_turret(turret):
	create_turret_texture_button(turret)

func create_turret_texture_button(turret):
	var button = TextureButton.new()
	button.custom_minimum_size = Vector2(64, 64)
	button.ignore_texture_size = true
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.name = turret["type"]
		
	var sprite_frames = load(turret["sprite_path"])
	if sprite_frames is SpriteFrames:
		var animated_sprite = AnimatedSprite2D.new()
		animated_sprite.sprite_frames = sprite_frames
		animated_sprite.animation = "gif"  # Adjust if your animation name is different
		animated_sprite.frame = 0
		animated_sprite.pause()
		animated_sprite.centered = false
		animated_sprite.scale = Vector2(64.0 / animated_sprite.sprite_frames.get_frame_texture("gif", 0).get_width(), 
										64.0 / animated_sprite.sprite_frames.get_frame_texture("gif", 0).get_height())
		button.add_child(animated_sprite)
		button.connect("pressed", Callable(self, "_on_turret_button_pressed").bind(turret["type"]))
		button.connect("mouse_entered", Callable(self, "_on_turret_button_hover").bind(animated_sprite))
		button.connect("mouse_exited", Callable(self, "_on_turret_button_hover_exit").bind(animated_sprite))
	else:
		button.texture_normal = sprite_frames  # In case it's a regular texture

	vbox_container.add_child(button)


func _on_turret_button_hover(animated_sprite):
	# Display hover text or start animation
	animated_sprite.play("gif")  # Start the animation on hover
	#print("Hovering over: ")
	# You could display a tooltip or start an animation here

func _on_turret_button_hover_exit(animated_sprite):
	# Hide hover text or stop animation
	animated_sprite.stop()  # Stop the animation when hover ends
	animated_sprite.frame = 0  # Optionally reset to the first frame
	#print("Stopped hovering")
	# Stop the tooltip or animation



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
