extends GenericEnemy


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	enemy_data = Globals.enemy_stats["Geometro"]
	scale = Vector2(2,2)
	#enemy_data.speed = 110
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
