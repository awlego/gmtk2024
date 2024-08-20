extends GenericEnemy


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	scale = Vector2(2,2)
	enemy_data.health = 250
	enemy_data.speed = 80
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walk(delta)

func apply_damage(damage):
	return super(damage-5)

