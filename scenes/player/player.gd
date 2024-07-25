class_name Player
extends RigidBody2D

signal is_stopped

@export var engine_thrust = 500
@export var engine_brake = 300
@export var spin_thrust = 1500

var thrust = Vector2()
var rotation_dir = 0
var screensize

@onready var trail_left = $PlayerTrailLeftWing as Line2D
@onready var trail_right = $PlayerTrailRightWing as Line2D

var _starting_pos: Vector2
var _starting_damp: float 
var _end_level_damp: float = 1.5

var _is_dumping := false

func _ready():
	GameManager.level_cleared.connect(_on_level_cleared)
	_starting_pos = position
	_starting_damp = linear_damp
	screensize = get_viewport().get_visible_rect().size


func _process(delta):
	_get_input()
	
	if _is_dumping and abs(linear_velocity) < Vector2.ONE:
		is_stopped.emit()


func _get_input():
	if Input.is_action_pressed("thrust") and not _is_dumping:
		thrust = transform.x * engine_thrust
	elif Input.is_action_pressed("break") and not _is_dumping:
		thrust = transform.x * -engine_brake
	else:
		thrust = Vector2()
	
	rotation_dir = 0
	
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1


func _integrate_forces(state):
	apply_force(thrust)
	apply_torque(rotation_dir * spin_thrust)
	
	if position.x > screensize.x:
		state.transform.origin.x = 0
		_jump_position()
	if position.x < 0:
		state.transform.origin.x = screensize.x
		_jump_position()
	if position.y > screensize.y:
		state.transform.origin.y = 0
		_jump_position()
	if position.y < 0:
		state.transform.origin.y = screensize.y
		_jump_position()


func _jump_position():
	GameManager.stop_drawing()
	trail_left.clear_points()
	trail_right.clear_points()


func _on_level_composed():
	_is_dumping = false
	linear_damp = _starting_damp


func _on_level_cleared():
	_is_dumping = true
	linear_damp = _end_level_damp

