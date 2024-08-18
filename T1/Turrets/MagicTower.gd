extends GenericTurret


# Called when the node enters the scene tree for the first time.
func _ready():
	turret_data = Globals.MAGIC_STATS
	scale = Vector2(2,2)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
