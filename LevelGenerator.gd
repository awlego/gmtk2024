extends Node
class_name LevelGenerator

const LEVEL_N = 16
const GRID_PX = 32

static var tileset
const TILESET_SIZE = 52

static func create_level(paths = BASIC_LEVEL):

	#var path = paths[0]
	
	var level = GenericT1Level.new()
	#var terrain_map = make_terrain_map()
	var tile_map = make_tile_map()
	for path in paths:
		var stepped_path = []
		if path.size() < 2:
			return create_level()

		for point in path:
			point.x = max(0, min(LEVEL_N-1, point.x))
			point.y = max(0, min(LEVEL_N-1, point.y))
		for i in range(path.size() - 1):
			stepped_path += path(path[i], path[i+1])
	
		var last_step = null
		# 0 = up, 1 = right, 2 = down, 3 = left
		var curr = path[0]

		var path_collision = Area2D.new()
		var pathbox = CollisionShape2D.new()
		pathbox.shape = RectangleShape2D.new()
		pathbox.shape.size = Vector2(1,1) * GRID_PX
		pathbox.position = GRID_PX * curr
		path_collision.add_child(pathbox)
		for step in stepped_path:
			step_dir(tile_map, curr, step, last_step)
			last_step = step
			curr += step
			pathbox = CollisionShape2D.new()
			pathbox.shape = RectangleShape2D.new()
			pathbox.shape.size = Vector2(1,1) * GRID_PX
			pathbox.position = GRID_PX * curr
			path_collision.add_child(pathbox)
		
		path_collision.collision_layer = Globals.PATH_LAYER
		path_collision.collision_mask = 0
		level.add_child(path_collision)

		var pathnode = Path2D.new()
		pathnode.curve = Curve2D.new()
		for v in path:
			pathnode.curve.add_point(v * GRID_PX)
		pathnode.add_child(EnemyFactory.new())
		level.add_child(pathnode)

	var background = Node2D.new()
	add_sprites(background, tile_map)
	level.add_child(background)

	level.scale *= 2.0
	return level

static func squarify_path(path, x_first=false):
	var p2 = []
	for i in range(path.size()):
		p2.append(path[i])
		if i+1 < path.size():
			if path[i].x != path[i+1].x and path[i].y != path[i+1].y:
				p2.append(Vector2(path[i+1].x, path[i].y) if x_first else Vector2(path[i].x, path[i+1].y))
	return p2
static func add_sprites(background, tile_map):
	for x in range(tile_map.size()):
		for y in range(tile_map[x].size()):
			var sprite = Sprite2D.new()
			sprite.position = GRID_PX * Vector2(x, y)
			sprite.position += Vector2(1,1) * GRID_PX / 2
			sprite.texture = tileset
			sprite.hframes = TILESET_SIZE
			sprite.frame = tile_map[x][y]
			background.add_child(sprite)
			
static func make_tile_map(x = LEVEL_N, y = LEVEL_N):
	var tm = []
	tm.resize(x)
	for i in range(x):
		tm[i] = []
		tm[i].resize(y)
		for j in range(y):
			tm[i][j] = G()
	return tm
	
static func make_terrain_map(x = LEVEL_N*2, y = LEVEL_N*2):
	var tm = []
	tm.resize(x)
	for i in range(x):
		tm[i] = []
		tm[i].resize(y)
		for j in range(y):
			tm[i][j] = 0
	return tm

static func step_dir(tile_map, curr, step, last):
	if step == Vector2.DOWN:
		step_down(tile_map, curr, last)
	elif step == Vector2.UP:
		step_up(tile_map, curr, last)
	elif step == Vector2.RIGHT:
		step_right(tile_map, curr, last)
	elif step == Vector2.LEFT:
		step_left(tile_map, curr, last)

# Vector2(0,1)
static func step_down(tile_map, curr, last):
	set_map_if(tile_map, curr.x, curr.y, E())
	set_map_if(tile_map, curr.x - 1, curr.y, W())
	if last == Vector2.RIGHT:
		set_map_if(tile_map, curr.x - 1, curr.y, SW_I())
		set_map_if(tile_map, curr.x, curr.y - 1, NE_O())
	elif last == Vector2.LEFT:
		set_map_if(tile_map, curr.x, curr.y, SE_I())
		set_map_if(tile_map, curr.x - 1, curr.y - 1, NW_O())

static func step_up(tm, curr, last):
	set_map_if(tm, curr.x, curr.y - 1, E())
	set_map_if(tm, curr.x - 1, curr.y - 1, W())
	if last == Vector2.RIGHT:
		set_map_if(tm, curr.x - 1, curr.y - 1, NW_I())
		set_map_if(tm, curr.x, curr.y, SE_O())
	elif last == Vector2.LEFT:
		set_map_if(tm, curr.x, curr.y - 1, NE_I())
		set_map_if(tm, curr.x - 1, curr.y, SW_O())

static func step_right(tm, curr, last):
	set_map_if(tm, curr.x, curr.y, S())
	set_map_if(tm, curr.x, curr.y - 1, N())
	if last == Vector2.DOWN:
		set_map_if(tm, curr.x, curr.y - 1, NE_I())
		set_map_if(tm, curr.x - 1, curr.y, SW_O())
	elif last == Vector2.UP:
		set_map_if(tm, curr.x, curr.y, SE_I())
		set_map_if(tm, curr.x - 1, curr.y - 1, NW_O())
		
static func step_left(tm, curr, last):
	set_map_if(tm, curr.x - 1, curr.y, S())
	set_map_if(tm, curr.x - 1, curr.y - 1, N())
	if last == Vector2.DOWN:
		set_map_if(tm, curr.x - 1, curr.y - 1, NW_I())
		set_map_if(tm, curr.x, curr.y, SE_O())
	elif last == Vector2.UP:
		set_map_if(tm, curr.x - 1, curr.y, SW_I())
		set_map_if(tm, curr.x, curr.y - 1, NE_O())

static func set_map_if(tm, x, y, val):
	if x < tm.size() and y < tm[0].size() and x >= 0 and y >= 0:
		tm[x][y] = val

static func blot_terrain_map(terrain_map, coordinate):
	var base_coord = 2 * coordinate
	terrain_map[base_coord.y][base_coord.x] = 1
	if base_coord.x > 1:
		terrain_map[base_coord.y][base_coord.x - 1] = 1
		
static func _static_init():
	_init_tileset()


static func _init_tileset():
	tileset = load("res://assets/T1/Levels/MapTileSet/PathTileSet-Sheet.bmp")

# 0: Empty
# 1: Path
const BASIC_LEVEL = [
		[Vector2(8,0), Vector2(8,12)]
	]

static func path(from : Vector2, to : Vector2):
	var curr := from
	var path = []
	while curr.distance_to(to) > 0:
		if curr.x != to.x:
			path.append(Vector2.RIGHT if curr.x < to.x else Vector2.LEFT)
		else:
			path.append(Vector2.DOWN if curr.y < to.y else Vector2.UP)
		curr += path[-1]
	return path

static func G():
	return randi_range(0,3)

static func N():
	return randi_range(4,7)
static func E():
	return randi_range(8,11)
static func S():
	return randi_range(12,15)
static func W():
	return randi_range(16,19)

static func NE_O():
	return randi_range(20,23)
static func SE_O():
	return randi_range(24,27)
static func SW_O():
	return randi_range(28,31)
static func NW_O():
	return randi_range(32,35)

static func NW_I():
	return randi_range(36,39)
static func NE_I():
	return randi_range(40,43)
static func SE_I():
	return randi_range(44,47)
static func SW_I():
	return randi_range(48,51)
	
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass



# LEVELS!!!

const LEVELS = [
	[ # 0
		[Vector2(3,0), Vector2(5,0), Vector2(5,5), Vector2(5,12), Vector2(12,12), 
			Vector2(12,5), Vector2(3,5), Vector2(3,16)]
	], [ # 1
		[Vector2(10,10), Vector2(10,7), Vector2(7,7), Vector2(7,10), Vector2(13,10),
			Vector2(13,4), Vector2(4,4), Vector2(4,16)]
	], [ # 2
		[Vector2(0,1), Vector2(15,1), Vector2(15,15), Vector2(1,15), Vector2(1,2)],
		[Vector2(4,4), Vector2(4,12), Vector2(12,12), Vector2(12,4), Vector2(5,4)],
	], [ # 3
		[Vector2(8,0), Vector2(8,12)]
	],
]

const LEVEL_BUFF_RATES = [
	1, 1.2, 1, 1.5
]
