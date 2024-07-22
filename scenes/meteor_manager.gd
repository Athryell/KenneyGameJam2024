extends Node2D

const COL_SIZE_LARGE := 23.0
const COL_SIZE_SMALL := 16.0
const BORDER_OFFSET = 50
const METEOR = preload("res://scenes/meteors/meteor.tscn")
const BLACK_HOLE = preload("res://scenes/black_hole.tscn")

@export_range(0, 500) var _distance_between_meteors: float = 100.0
@export var meteor_sprites: Array[Texture2D]
@export var meteor_colors: Array[Color]

var _spawn_area
var _rand_positions: Array[Vector2] = []
var _sprites_array
var _colors_array
var _min_distance

@onready var player = %Player
@onready var spawn_area = $"../SpawnArea"

func _ready():
	_spawn_area = spawn_area.get_node("CollisionShape2D").shape.size
	_min_distance = COL_SIZE_LARGE * 2 + _distance_between_meteors 


func setup_level(elements: Dictionary):
	_sprites_array = meteor_sprites.duplicate()
	_colors_array = meteor_colors.duplicate()
	setup_meteors_families(elements["families"], elements["twins_amount"])
	setup_black_holes(elements["black_holes"])
	
	var cam = get_tree().root.get_node("/root/LevelManager").get_child(0).get_node("Camera")
	cam.zoom_intro()


func setup_meteors_families(amount_of_families, range_of_twin_amount: Array):
	for i in amount_of_families:
		var amount = range_of_twin_amount.pick_random()
		_create_meteors_twins(i, amount) #HACK Magic number for number of twins, manage it from level loader


func _create_meteors_twins(type: int, twin_amount: int):
	var t = _sprites_array.pick_random()
	var c = _colors_array.pick_random()
	print(_colors_array.size())
	
	for twin in twin_amount:
		_create_meteor(type, twin, twin_amount, t, c)
	
	_sprites_array.remove_at(_sprites_array.find(t))
	_colors_array.remove_at(_colors_array.find(c))


func _create_meteor(type: int, twin: int, twin_amount: int, txtr: Texture2D, color: Color):
	var new_meteor = METEOR.instantiate() as Area2D
	new_meteor.position = _get_rand_pos()
	
	var sprite = new_meteor.get_node("Sprite2D") as Sprite2D
	sprite.texture = txtr
	sprite.self_modulate = color
	
	add_child(new_meteor)
	
	var new_col = CollisionShape2D.new()
	new_col.shape = CircleShape2D.new()
	new_meteor.add_child(new_col)
	
	if txtr.resource_path.get_file().split(".")[0].to_lower().find("small") != -1: # C'è "small" nel path
		new_col.shape.set_radius(COL_SIZE_SMALL)
	else:
		new_col.shape.set_radius(COL_SIZE_LARGE)
	
	new_meteor.set_twin_info(type, twin, twin_amount)
	new_meteor.player = player



func _get_rand_pos() -> Vector2i:
	var rand_pos = Vector2(randi_range(BORDER_OFFSET, _spawn_area.x - BORDER_OFFSET),
						randi_range(BORDER_OFFSET, _spawn_area.y - BORDER_OFFSET))
	
	for pos in _rand_positions:
		if pos.distance_to(rand_pos) < _min_distance:
			return _get_rand_pos() #HACK recursive? LOL
	
	_rand_positions.append(rand_pos)
	return rand_pos
		

func setup_black_holes(amount):
	for _i in amount:
		var new_bh = BLACK_HOLE.instantiate() as StaticBody2D
		add_child(new_bh)
		new_bh.position = _get_rand_pos()
