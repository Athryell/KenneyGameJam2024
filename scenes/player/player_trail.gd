extends Line2D

@export var length = 50
@export var is_left_trail: bool

var point = Vector2()

@onready var player_trail_starting_point_left = $"../PlayerTrailStartingPointLeft"
@onready var player_trail_starting_point_right = $"../PlayerTrailStartingPointRight"


func _process(delta):
	global_position = Vector2.ZERO
	global_rotation = 0
	
	if is_left_trail:
		point = player_trail_starting_point_left.global_position
	else:
		point = player_trail_starting_point_right.global_position
		
	add_point(point)
	
	while get_point_count() > length:
		remove_point(0)
