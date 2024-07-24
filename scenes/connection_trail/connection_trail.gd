extends Line2D

const COMPLETED_TRAIL_PARTICLES_SCENE = preload("res://scenes/connection_trail/completed_trail_particles.tscn")

var draw_point

@onready var trail_collision_body = $StaticBody2D

func update_collision_shape():
	if points.size() < 2:
		return
	
	await highlight_completed_trail()
	
	var i = 0
	while i < points.size() - 1:
		var collision_shape = CollisionShape2D.new()
		var shape = SegmentShape2D.new()
		shape.a = points[i]
		shape.b = points[i + 1]
		collision_shape.shape = shape
		trail_collision_body.add_child(collision_shape)
		
		i += 1


func highlight_completed_trail():
	var particles = COMPLETED_TRAIL_PARTICLES_SCENE.instantiate()
	add_child(particles)
	
	particles.emitting = true
	
	var j = 0
	while j < points.size() - 1:
		particles.position = points[j]
		await get_tree().create_timer(0.03).timeout
		j += 1
	particles.emitting = false


func _on_add_point_timer_timeout():
	var point = draw_point.global_position - global_position
	add_point(point)

