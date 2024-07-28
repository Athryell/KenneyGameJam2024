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
var _end_level_damp: float = 3

var target_rotation = -90
var rotation_tolerance = 4
var _is_dumping := false
var timer_reset_rot

func _ready():
	GameManager.level_cleared.connect(_on_level_cleared)
	_starting_pos = position
	_starting_damp = linear_damp
	screensize = get_viewport().get_visible_rect().size


func _process(delta):
	_get_input()


func _get_input():
	if _is_dumping:
		return
		
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_thrust
	elif Input.is_action_pressed("break"):
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
	_jump_position()


func _on_level_cleared():
	_is_dumping = true
	linear_damp = _end_level_damp

	timer_reset_rot = Timer.new()
	timer_reset_rot.wait_time = 0.1
	timer_reset_rot.timeout.connect(_check_rotation)
	add_child(timer_reset_rot)
	timer_reset_rot.start()

#region Logic to handle rotation reset after completing level
func _check_rotation():
	if _is_near_target_angles(int(rotation_degrees), rotation_tolerance):
		set_angular_velocity(0)
		#rotation_degrees = target_rotation
		is_stopped.emit()
		timer_reset_rot.queue_free()
	else:
		if _is_facing_right():
			set_angular_velocity(-3)
		else:
			set_angular_velocity(3)


func _is_near_target_angles(value, tolerance):
	return _is_near_angle(value, -90, tolerance) or _is_near_angle(value, 270, tolerance)


func _is_near_angle(value, target, tolerance):
	var diff = abs((value - target + 180) % 360 - 180)
	return diff <= tolerance


func _is_facing_right():
	return rotation_degrees >= -90 and rotation_degrees <= 90
#endregion
