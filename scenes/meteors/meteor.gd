class_name Meteor
extends Area2D

#signal starting_connection(pos)

var starting_col: Color
@export var highlight_col: Color

const CONNECTION_TRAIL = preload("res://scenes/connection_trail/connection_trail.tscn")

#var _info_dict: Dictionary
var type: int # This is to match the other twins to connect to
var count: int # This is to check if the twin is not self
var total_twins: int # This is to check if all the twins are connected
#var color: Color # Maybe needed for some cool effect
var player
var trail
var is_connection_completed

@onready var sprite = $Sprite2D as Sprite2D
@onready var particles = $GPUParticles2D

func set_twin_info(meteor_type: int, meteor_count: int, twin_amount: int):
	type = meteor_type
	count = meteor_count
	total_twins = twin_amount
	starting_col = sprite.self_modulate
	particles.self_modulate = starting_col


func _on_body_entered(body):
	if is_connection_completed:
		return
	
	particles.emitting = true
	
	var active_meteor = GameManager.get_active_meteor()
	
	if active_meteor and active_meteor.trail: # A trail is active
		if active_meteor.type == type and active_meteor.count != count: # Is a twin meteor!
			# TODO: Check only for the type and if match check if it's already in an Array,
			# but it will be refactor anyway this shitty code lol
			GameManager.connections_completed += 1
			if GameManager.are_all_connections_completed():
				GameManager.add_meteor_to_list(self)
				GameManager.complete_connection(self)
				if  GameManager.total_connections_completed == LevelManager.game_elements["families"]:
					var cam = get_tree().root.get_node("/root/LevelManager").get_child(0).get_node("Camera")
					cam.zoom_outro() # HACK One of the ugliest code ever seen
			else:
				GameManager.add_meteor_to_list(self)
			return

		GameManager.stop_drawing()

	GameManager.set_meteor_info(self)
	draw_connection()


func draw_connection():	
	trail = CONNECTION_TRAIL.instantiate()
	trail.draw_point = player.get_node("DrawStartingPoint")
	trail.default_color = starting_col
	trail.add_point(position - global_position)
	add_child(trail)

#
#func flash_highlight():
	#sprite.self_modulate = highlight_col
	#get_tree().create_timer(1).timeout
	#sprite.self_modulate = starting_col
