extends Camera2D

#signal outro_camera_finished

@export var _close_up_zoom := Vector2(4, 4)
@export var _animation_duration: float = 2.0

var _starting_zoom := Vector2(1, 1)
var _startin_pos: Vector2
var _player_cam: Camera2D

@onready var player = %Player
@onready var level_composer = $"../LevelComposer"


func _ready():
	level_composer.level_composed.connect(_level_intro)
	player.is_stopped.connect(_level_outro)
	
	_player_cam = player.get_node("CameraPlayer") as Camera2D
	
	_starting_zoom = zoom
	_startin_pos = position


func _level_intro():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "zoom", _starting_zoom, _animation_duration) \
			.from(_close_up_zoom) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", _startin_pos, _animation_duration) \
			.from(_player_cam.global_position) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_SINE)


func _level_outro():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(self, "zoom", _close_up_zoom, _animation_duration) \
			.from(_starting_zoom) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", _player_cam.global_position, _animation_duration) \
			.from(_startin_pos) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_SINE)
	tween.chain().tween_callback(LevelManager.go_to_next_level)
			

	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "zoom", Vector2.ONE * _close_up_zoom, _animation_duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#tween.tween_callback(func(): self.position_smoothing_enabled = false)
	#tween.parallel().tween_callback(func(): outro_camera_finished.emit())
	#tween.tween_callback(func(): self.position = _startin_pos)
	#tween.tween_callback(func(): self.position_smoothing_enabled = true)
