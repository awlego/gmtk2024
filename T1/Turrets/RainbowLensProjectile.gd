extends Node2D

@onready var sprite_texture: Texture2D = preload("res://assets/T1/Turrets/RainbowLens/RainbowLensProjectile.png")
var start_position: Vector2
var end_position: Vector2
var alpha: float = 1.0

func _ready():
	z_index = Globals.Z_ATTACK - 1

func _process(delta):
	alpha -= 1 * delta
	if alpha <= 0:
		queue_free()
	queue_redraw()  # This will call _draw() on the next frame

func setup(firing_tower: GenericTurret, target: Area2D) -> void:
	start_position = to_local(firing_tower.global_position)
	end_position = to_local(target.global_position)

func _draw():
	var distance_to_target = start_position.distance_to(end_position)
	var sprite_size = 16
	var num_sprites = ceil(distance_to_target / sprite_size)
	var direction = (end_position - start_position).normalized()
	var angle = direction.angle() + deg_to_rad(45)

	for i in range(num_sprites):
		if i == 0:
			continue
		var sprite_position = start_position + direction * i * sprite_size
		draw_set_transform(sprite_position, angle, Vector2(1, 1))
		draw_texture(sprite_texture, -Vector2(sprite_size / 2, sprite_size / 2), Color(1, 1, 1, alpha))
	
	# Reset the transform
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)
