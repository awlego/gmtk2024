extends Node2D

@export var grid_size: int = 64 # Size of each cell in the grid (e.g., 64x64 pixels)
@export var grid_width: int = 8 # Number of columns
@export var grid_height: int = 8 # Number of rows

# 2D array to store which cells are occupied
var grid_data: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize the grid data
	grid_data.resize(grid_width)
	for x in range(grid_width):
		grid_data[x] = []
		for y in range(grid_height):
			grid_data[x].append(false) # false means the cell is empty
	
	place_tower(preload("res://T1/Turrets/blood_turret.tscn"), Vector2(250,250))
	place_tower(preload("res://T1/Turrets/PulseTurret.tscn"), Vector2(350,350))
	place_tower(preload("res://T1/Turrets/LightningTurret.tscn"), Vector2(150,150))
	

# Convert world position to grid position
func world_to_grid(world_position: Vector2) -> Vector2:
	return Vector2(floor(world_position.x / grid_size), floor(world_position.y / grid_size))

# Convert grid position to world position
func grid_to_world(grid_position: Vector2) -> Vector2:
	return grid_position * grid_size

# Check if a cell is free
func is_cell_free(grid_position: Vector2) -> bool:
	if grid_position.x >= 0 and grid_position.x < grid_width and grid_position.y >= 0 and grid_position.y < grid_height:
		return not grid_data[grid_position.x][grid_position.y]
	return false

# Place a tower in the grid
func place_tower(tower_scene: PackedScene, world_position: Vector2):
	var grid_position = world_to_grid(world_position)
	if is_cell_free(grid_position):
		var tower = tower_scene.instantiate()
		# tower.level = get_parent()
		tower.real_tower = true
		tower.position = grid_to_world(grid_position)
		add_child(tower)
		grid_data[grid_position.x][grid_position.y] = true
		return true
	return false
