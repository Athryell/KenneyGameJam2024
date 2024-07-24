extends Camera2D

signal outro_camera_finished

@export var _close_up_zoom: int = 3
@export var _animation_duration: float = 2.0

@onready var player = %Player
@onready var level_composer = $"../LevelComposer"


func _ready():
	set_process(false)
	level_composer.level_composed.connect(_level_intro)
	GameManager.level_cleared.connect(_level_outro)
	zoom = Vector2.ONE * _close_up_zoom
	_level_intro()


func _process(delta):
	position = player.global_position


func _level_intro():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2.ONE, _animation_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _level_outro():
	set_process(true)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2.ONE * _close_up_zoom, _animation_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(func(): set_process(false))
	tween.tween_callback(func(): outro_camera_finished.emit())

	
