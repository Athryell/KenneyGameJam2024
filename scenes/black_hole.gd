extends Sprite2D

@export var rot_speed := -2.0

func _process(delta):
	rotate(rot_speed * delta)
