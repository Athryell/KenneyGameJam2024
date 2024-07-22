extends Line2D

@onready var draw_point = $"../../Meteor"


@onready var change_size_timer = $ChangeSizeTimer
@onready var particles = $GPUParticles2D



func _on_add_point_timer_timeout():
	var point = draw_point.global_position - global_position
	add_point(point)



#var point_size = 0.5
#var point_index = 0
#var time_passed = 0.0
#
#
#func _on_change_size_timer_timeout():
	#time_passed += change_size_timer.wait_time
#
	#point_size = 0.5 + 0.25 * sin(time_passed * 2 * PI)
#
	#for i in width_curve.point_count:
		#width_curve.set_point_value(i, point_size)

