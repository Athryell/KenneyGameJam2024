extends Node2D

@onready var part_thrust = $GPUParticles_Thrust as CPUParticles2D
@onready var part_break_left = $GPUParticles_Break_Left as CPUParticles2D
@onready var part_break_right = $GPUParticles_Break_Right as CPUParticles2D
@onready var part_spin_left_top = $GPUParticles_SpinLeft_Top as CPUParticles2D
@onready var part_spin_left_bottom = $GPUParticles_SpinLeft_Bottom as CPUParticles2D
@onready var part_spin_right_top = $GPUParticles_SpinRight_Top as CPUParticles2D
@onready var part_spin_right_bottom = $GPUParticles_SpinRight_Bottom as CPUParticles2D

@onready var animated_sprite_2d = $GPUParticles_Thrust/Sprite_Thrust
@onready var sprite_break_left = $GPUParticles_Break_Left/Sprite_BreakLeft
@onready var sprite_break_right = $GPUParticles_Break_Right/Sprite_BreakRight
@onready var sprite_spin_left_top = $GPUParticles_SpinLeft_Top/Sprite_SpinLeft_Top
@onready var sprite_spin_left_bottom = $GPUParticles_SpinLeft_Bottom/Sprite_SpinLeft_Bottom
@onready var sprite_spin_right_top = $GPUParticles_SpinRight_Top/Sprite_SpinRight_Top
@onready var sprite_spin_right_bottom = $GPUParticles_SpinRight_Bottom/Sprite_SpinRight_Bottom


func _process(delta):
	if Input.is_action_pressed("thrust"):
		part_thrust.emitting = true
		animated_sprite_2d.visible = true
	elif Input.is_action_pressed("break"):
		part_break_left.emitting = true
		part_break_right.emitting = true
		sprite_break_left.visible = true
		sprite_break_right.visible = true
	else:
		part_thrust.emitting = false
		animated_sprite_2d.visible = false
		part_break_left.emitting = false
		part_break_right.emitting = false
		sprite_break_left.visible = false
		sprite_break_right.visible = false
	
	if Input.is_action_pressed("rotate_right"):
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
		part_spin_left_top.emitting = true
		part_spin_left_bottom.emitting = true
		sprite_spin_left_top.visible = true
		sprite_spin_left_bottom.visible = true
	if Input.is_action_just_released("rotate_left"):
		part_spin_left_top.emitting = false
		part_spin_left_bottom.emitting = false
		sprite_spin_left_top.visible = false
		sprite_spin_left_bottom.visible = false
