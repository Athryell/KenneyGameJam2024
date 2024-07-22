extends Node

var current_level: int = 0
var _current_level_scene

const LEVEL_SCENE = preload("res://scenes/level.tscn")

var game_elements: Dictionary

func _ready():
	go_to_level(current_level)
	
#func load_starting_level():
	#current_level = 0
	#go_to_level(current_level)
	#pass #TODO: do starting level

func go_to_next_level():
	current_level += 1
	go_to_level(current_level)

func go_to_level(level):
	game_elements.clear()
	if _current_level_scene:
		_current_level_scene.queue_free()
	
	match level:
		0: 
			game_elements["families"] = 2
			game_elements["twins_amount"] = [2]
			game_elements["black_holes"] = 0
			#game_elements["families"] = 2
			#game_elements["twins_amount"] = [2]
			#game_elements["black_holes"] = 0
		1:
			game_elements["families"] = 4
			game_elements["twins_amount"] = [2]
			game_elements["black_holes"] = 1
		2:
			game_elements["families"] = 2
			game_elements["twins_amount"] = [4]
			game_elements["black_holes"] = 0
		3:
			game_elements["families"] = 3
			game_elements["twins_amount"] = [3]
			game_elements["black_holes"] = 2
		_:
			#load_starting_level()
			print("The Game is Over!")
	
	GameManager.total_connections_completed = 0
	
	var l = LEVEL_SCENE.instantiate()
	l.name = "Level"
	add_child(l)
	l.get_node("MeteorsManager").setup_level(game_elements)
	_current_level_scene = l
	
