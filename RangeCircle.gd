extends Node2D

var radius = 5
var color = Color(1, 1, 1, 0.2)

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func _process(_delta):
	queue_redraw()
