extends Node2D

@onready var num_img_path = "res://assets/T1/Turrets/hud_%s.png"
var number_images = {}
var prev_health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	z_as_relative = false
	z_index = Globals.Z_GUI
	Globals.update_health_ui_ref = Callable(self, "update_health_ui")
	for i in range(0, 10):
		number_images[i] = load(num_img_path % i)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func flash_red():
	$ones_digit.modulate = Color.RED
	$tens_digit.modulate = Color.RED
	$hundreds_digit.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$ones_digit.modulate = Color.WHITE
	$tens_digit.modulate = Color.WHITE
	$hundreds_digit.modulate = Color.WHITE


func update_health_ui(health):
	
	var nstr = "%03d" % health  # Format the number as a 5-digit string, padding with zeros if necessary
	var ones_digit = int(nstr[-1])
	var tens_digit = int(nstr[-2])
	var hundreds_digit = int(nstr[-3])

	$ones_digit.texture = number_images[ones_digit]
	$tens_digit.texture = number_images[tens_digit]
	$hundreds_digit.texture = number_images[hundreds_digit]

	if(health < prev_health):
		flash_red()
	prev_health = health


