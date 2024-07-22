extends Camera2D

@onready var animation_player:AnimationPlayer = $AnimationPlayer

func zoom_intro():
	animation_player.play("zoom_out_ship")

func zoom_outro():
	animation_player.play("zoom_out_world")
	await animation_player.animation_finished
	LevelManager.go_to_next_level()
