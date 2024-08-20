extends Control

signal turret_selected(turret_type)
@onready var vbox_container = $VBoxContainer

# A list of dictionaries containing the turret type and corresponding sprite path
var starting_turrets = [
	{"type": "blood_turret", "sprite_path": "res://assets/T1/Turrets/Blood/BloodShooter.gif", "stats": Globals.BLOOD_STATS},
	{"type": "PulseTurret", "sprite_path": "res://assets/T1/Turrets/Pulse/PulseTowerAttack.gif", "stats": Globals.PULSE_STATS},
	{"type": "LightningTurret", "sprite_path": "res://assets/T1/Turrets/Lightning/LightningTower.gif", "stats": Globals.LIGHTNING_STATS},
	{"type": "MagicTower", "sprite_path": "res://assets/T1/Turrets/Magic/MagicTower.gif", "stats": Globals.MAGIC_STATS},
	{"type": "RainbowLensTurret", "sprite_path": "res://assets/T1/Turrets/RainbowLens/RainbowLensTurret.gif", "stats": Globals.RAINBOW_LENS_STATS},
	{"type": "SnowTurret", "sprite_path": "res://assets/T1/Turrets/Snow/SnowTower.gif", "stats": Globals.SNOW_STATS},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$VBoxContainer.add_theme_constant_override("separation", 24)
	
	var i = 1
	for turret in starting_turrets:
		var turret_card = create_turret_card(turret)
		$VBoxContainer.add_child(turret_card)

		var action_name = "select_turret_%s" % str(i)
		InputMap.add_action(action_name)
		var event = InputEventKey.new()
		event.physical_keycode = KEY_0 + i # Assign the key programmatically

		InputMap.action_add_event(action_name, event)
		i += 1
		
	

func create_turret_card(turret: Dictionary):
		# create a vbox container with the turret cost below each turret button
		var turret_card = VBoxContainer.new()
		var turret_button = create_turret_texture_button(turret)
		var cost_label = create_cost_label(turret)
		
		turret_card.add_child(turret_button)
		turret_card.add_child(cost_label)
		
		return turret_card

	
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

	return button
	#vbox_container.add_child(button)

func create_cost_label(turret):
	var label = Label.new()
	label.text = "$" + str(turret['stats'].cost)
	return label
	#add_child(label)

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
	if Input.is_action_just_pressed("select_turret_1"):
		turret_selected.emit(starting_turrets[0]['type'])
	elif Input.is_action_just_pressed("select_turret_2"):
		turret_selected.emit(starting_turrets[1]['type'])
	elif Input.is_action_just_pressed("select_turret_3"):
		turret_selected.emit(starting_turrets[2]['type'])
	elif Input.is_action_just_pressed("select_turret_4"):
		turret_selected.emit(starting_turrets[3]['type'])
	elif Input.is_action_just_pressed("select_turret_5"):
		turret_selected.emit(starting_turrets[4]['type'])
	elif Input.is_action_just_pressed("select_turret_6"):
		turret_selected.emit(starting_turrets[5]['type'])
