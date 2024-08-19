extends Node2D

@onready var num_img_path = "res://assets/T1/Turrets/hud_%s.png"
var number_images = {}
var dummy_money = 0
var prev_money = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.update_bank_ui_ref = Callable(self, "update_bank_ui")
	for i in range(0, 10):
		number_images[i] = load(num_img_path % i)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#dummy_money += 1
	#update_bank_ui(dummy_money)
	pass


func flash_red():
	$ones_digit.modulate = Color.RED
	$tens_digit.modulate = Color.RED
	$hundreds_digit.modulate = Color.RED
	$thousands_digit.modulate = Color.RED
	$ten_thousands_digit.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$ones_digit.modulate = Color.WHITE
	$tens_digit.modulate = Color.WHITE
	$hundreds_digit.modulate = Color.WHITE
	$thousands_digit.modulate = Color.WHITE
	$ten_thousands_digit.modulate = Color.WHITE


func update_bank_ui(money):
	
	var nstr = "%05d" % money  # Format the number as a 5-digit string, padding with zeros if necessary
	var ones_digit = int(nstr[-1])
	var tens_digit = int(nstr[-2])
	var hundreds_digit = int(nstr[-3])
	var thousands_digit = int(nstr[-4])
	var ten_thousands_digit = int(nstr[-5])

	$ones_digit.texture = number_images[ones_digit]
	$tens_digit.texture = number_images[tens_digit]
	$hundreds_digit.texture = number_images[hundreds_digit]
	$thousands_digit.texture = number_images[thousands_digit]
	$ten_thousands_digit.texture = number_images[ten_thousands_digit]
	
	if(money < prev_money):
		flash_red()
	prev_money = money


