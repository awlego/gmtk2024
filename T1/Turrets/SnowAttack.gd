extends AreaAttack

var direction
var speed
var duration
var scale_rate

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_layer = Globals.ATTACK_LAYER
	collision_mask = Globals.ENEMY_LAYER
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	duration -= delta
	scale += Vector2(1,1) * scale_rate * delta
	if duration <= 0:
		queue_free()
