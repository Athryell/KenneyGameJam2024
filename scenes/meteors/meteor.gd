class_name Meteor
extends Area2D

signal twin_found(obj: Meteor)

const CONNECTION_TRAIL = preload("res://scenes/connection_trail/connection_trail.tscn")

@export var highlight_col: Color

var type: int # This is to match the other twins to connect to
var count: int # This is to check if the twin is not self
var total_twins: int # This is to check if all the twins are connected
var starting_col: Color
var player
var trail
var is_connection_completed

@onready var sprite = $Sprite2D as Sprite2D
@onready var particles = $GPUParticles2D


func _ready():
	self.twin_found.connect(GameManager._on_twin_found)


func set_twin_info(meteor_type: int, meteor_count: int, twin_amount: int):
	type = meteor_type
	count = meteor_count
	total_twins = twin_amount
	starting_col = sprite.self_modulate
	particles.self_modulate = starting_col

func _on_area_entered(area):
	if not area.get_parent() is Player or is_connection_completed:
		return
	
	particles.emitting = true
	
	var active_meteor = GameManager.get_active_meteor()
	
	if active_meteor and active_meteor.trail: # A trail is active
		if active_meteor.type == type and active_meteor.count != count: # Is a twin meteor!
			twin_found.emit(self)
			return

		GameManager.stop_drawing()

	GameManager.set_meteor_info(self)
	_start_draw_new_connection()


func _start_draw_new_connection():	
	trail = CONNECTION_TRAIL.instantiate()
	trail.draw_point = player.get_node("ConnectionTrailAreaDetection")
	trail.default_color = starting_col
	trail.add_point(position - global_position)
	add_child(trail)



