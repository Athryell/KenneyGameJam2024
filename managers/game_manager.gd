extends Node

signal level_cleared

var total_connections_completed: int
var connections_completed_in_family: int = 0

var _total_connection_needed: int
var _active_meteor: Meteor
var _meteor_list: Array[Meteor]

func _ready():
	LevelManager.level_data_loaded.connect(_on_level_data_loaded)


func set_meteor_info(meteor):
	_active_meteor = meteor
	_add_meteor_to_list(_active_meteor)


func get_active_meteor() -> Meteor:
	return _active_meteor


func stop_drawing():
	if _active_meteor and _active_meteor.trail:
		_active_meteor.trail.queue_free()
		_active_meteor = null
	_reset_data()


func _add_meteor_to_list(meteor: Meteor):
	_meteor_list.append(meteor)


func _complete_connection(last_meteor):
	_active_meteor.trail.get_node("AddPointTimer").queue_free()
	_active_meteor.trail.add_point(last_meteor.position - _active_meteor.trail.global_position)
	_active_meteor.trail.update_collision_shape()
	total_connections_completed += 1

	for m in _meteor_list:
		m.is_connection_completed = true
	
	_reset_data()
	
	if  total_connections_completed == _total_connection_needed:
		level_cleared.emit()


func _on_twin_found(obj: Meteor):
	connections_completed_in_family += 1
	_add_meteor_to_list(obj)
	if connections_completed_in_family == _active_meteor.total_twins - 1:
		_complete_connection(obj)


func _on_level_data_loaded(game_data):
	_total_connection_needed = game_data["families"]
	total_connections_completed = 0
	_reset_data()


func _reset_data():
	_active_meteor = null
	_meteor_list.clear()
	connections_completed_in_family = 0

