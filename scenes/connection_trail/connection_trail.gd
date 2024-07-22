extends Line2D

var draw_point

@onready var static_body = $StaticBody2D
@onready var change_size_timer = $ChangeSizeTimer
@onready var particles = $GPUParticles2D



func update_collision_shape():
	if points.size() < 2:
		return

	await get_tree().create_timer(1).timeout
	
	
		
	var i = 0
	while i < points.size() - 1:
		var collision_shape = CollisionShape2D.new()
		var shape = SegmentShape2D.new()
		shape.a = points[i]
		shape.b = points[i + 1]
		collision_shape.shape = shape
		static_body.add_child(collision_shape)
		
		particles.position = points[i]
		
		i += 1
	
	
	var j = 0
	while j < points.size() - 1:
		particles.emitting = true
		particles.position = points[j]
		print(points[j])
		await get_tree().create_timer(0.03).timeout
		j += 1
	particles.emitting = false


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

