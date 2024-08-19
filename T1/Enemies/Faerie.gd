extends GenericEnemy
class_name Faerie

const FPS = 20
const SPF = 1.0/FPS
var time_to_frame = SPF
@onready var sprite = Sprite2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var color = Globals.faeries.pick_random()
	enemy_data = Globals.faerie_stats[color]

	#image.load()
	#var texture = ImageTexture.new()
	#texture.create_from_image(image)
	sprite.texture = Globals.faerie_sprites[color]
	#print(sprite.texture)
	#sprite.texture = texture
	sprite.rotation_degrees = -90
	sprite.hframes = 4
	add_child(sprite)
	
	var x = CollisionShape2D.new()
	var s = CircleShape2D.new()
	s.radius = 12
	x.shape = s
	add_child(x)
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameup(delta)
	super(delta)
	pass

func frameup(delta):
	time_to_frame -= delta
	if time_to_frame<0:
		sprite.frame = (sprite.frame + 1) % 4
		time_to_frame = SPF
