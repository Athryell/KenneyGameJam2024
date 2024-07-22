extends Node

var total_connections_completed: int
var connections_completed: int = 0

var _active_meteor: Meteor
var _meteor_list: Array[Meteor]


func stop_drawing():
	if _active_meteor and _active_meteor.trail:
		_active_meteor.trail.queue_free()
		_active_meteor = null
	_reset_data()


func are_all_connections_completed() -> bool:
	if connections_completed == _active_meteor.total_twins - 1:
		return true
	return false


func add_meteor_to_list(meteor: Meteor):
	_meteor_list.append(meteor)


func complete_connection(last_meteor):
	_active_meteor.trail.get_node("AddPointTimer").queue_free()
	_active_meteor.trail.add_point(last_meteor.position - _active_meteor.trail.global_position)
	_active_meteor.trail.update_collision_shape()
	total_connections_completed += 1

	for m in _meteor_list:
		m.is_connection_completed = true
	
	_reset_data()


func _reset_data():
	_active_meteor = null
	_meteor_list.clear()
	connections_completed = 0


func set_meteor_info(meteor):
	_active_meteor = meteor
	add_meteor_to_list(_active_meteor)


func get_active_meteor() -> Meteor:
	return _active_meteor

