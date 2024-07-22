extends RigidBody2D

@export var engine_thrust = 500
@export var engine_brake = 300
@export var spin_thrust = 1500

var thrust = Vector2()
var rotation_dir = 0
var screensize

@onready var part_thrust = $VFX/GPUParticles_Thrust as GPUParticles2D
@onready var part_break_left = $VFX/GPUParticles_Break_Left as GPUParticles2D
@onready var part_break_right = $VFX/GPUParticles_Break_Right as GPUParticles2D
@onready var part_spin_left_top = $VFX/GPUParticles_SpinLeft_Top as GPUParticles2D
@onready var part_spin_left_bottom = $VFX/GPUParticles_SpinLeft_Bottom as GPUParticles2D
@onready var part_spin_right_top = $VFX/GPUParticles_SpinRight_Top as GPUParticles2D
@onready var part_spin_right_bottom = $VFX/GPUParticles_SpinRight_Bottom as GPUParticles2D

@onready var animated_sprite_2d = $VFX/GPUParticles_Thrust/Sprite_Thrust
@onready var sprite_break_left = $VFX/GPUParticles_Break_Left/Sprite_BreakLeft
@onready var sprite_break_right = $VFX/GPUParticles_Break_Right/Sprite_BreakRight
@onready var sprite_spin_left_top = $VFX/GPUParticles_SpinLeft_Top/Sprite_SpinLeft_Top
@onready var sprite_spin_left_bottom = $VFX/GPUParticles_SpinLeft_Bottom/Sprite_SpinLeft_Bottom
@onready var sprite_spin_right_top = $VFX/GPUParticles_SpinRight_Top/Sprite_SpinRight_Top
@onready var sprite_spin_right_bottom = $VFX/GPUParticles_SpinRight_Bottom/Sprite_SpinRight_Bottom


func _ready():
	screensize = get_viewport().get_visible_rect().size

func get_input():
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_thrust
		part_thrust.emitting = true
		animated_sprite_2d.visible = true
	elif Input.is_action_pressed("break"):
		thrust = transform.x * -engine_brake
		part_break_left.emitting = true
		part_break_right.emitting = true
		sprite_break_left.visible = true
		sprite_break_right.visible = true
	else:
		thrust = Vector2()
		part_thrust.emitting = false
		animated_sprite_2d.visible = false
		part_break_left.emitting = false
		part_break_right.emitting = false
		sprite_break_left.visible = false
		sprite_break_right.visible = false
	
	rotation_dir = 0
	if Input.is_action_pressed("rotate_right"):
		rotation_dir += 1
		part_spin_right_top.emitting = true
		part_spin_right_bottom.emitting = true
		sprite_spin_right_top.visible = true
		sprite_spin_right_bottom.visible = true
	if Input.is_action_just_released("rotate_right"):
		part_spin_right_top.emitting = false
		part_spin_right_bottom.emitting = false
		sprite_spin_right_top.visible = false
		sprite_spin_right_bottom.visible = false
		
	if Input.is_action_pressed("rotate_left"):
		rotation_dir -= 1
		part_spin_left_top.emitting = true
		part_spin_left_bottom.emitting = true
		sprite_spin_left_top.visible = true
		sprite_spin_left_bottom.visible = true
	if Input.is_action_just_released("rotate_left"):
		part_spin_left_top.emitting = false
		part_spin_left_bottom.emitting = false
		sprite_spin_left_top.visible = false
		sprite_spin_left_bottom.visible = false

func _process(delta):
	get_input()


func _integrate_forces(state):
	apply_force(thrust)
	apply_torque(rotation_dir * spin_thrust)
	
	if position.x > screensize.x:
		state.transform.origin.x = 0
		GameManager.stop_drawing()
	if position.x < 0:
		state.transform.origin.x = screensize.x
		GameManager.stop_drawing()
	if position.y > screensize.y:
		state.transform.origin.y = 0
		GameManager.stop_drawing()
	if position.y < 0:
		state.transform.origin.y = screensize.y
		GameManager.stop_drawing()

func _draw():
	pass
