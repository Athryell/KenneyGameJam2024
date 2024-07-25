extends Node

signal level_data_loaded(game_elements: Dictionary)

var _current_level: int = 0

var _game_elements: Dictionary

#func load_starting_level():
	#current_level = 0
	#go_to_level(current_level)
	#pass #TODO: do starting level


func go_to_next_level():
	_current_level += 1
	go_to_level(_current_level)


func go_to_level(level):
	_game_elements.clear()
	
	match level:
		0: 
			_game_elements["families"] = 1
			_game_elements["twins_amount"] = [2]
			_game_elements["black_holes"] = 0
			#_game_elements["families"] = 2
			#_game_elements["twins_amount"] = [2]
			#_game_elements["black_holes"] = 0
		1:
			_game_elements["families"] = 4
			_game_elements["twins_amount"] = [2]
			_game_elements["black_holes"] = 1
		2:
			_game_elements["families"] = 2
			_game_elements["twins_amount"] = [4]
			_game_elements["black_holes"] = 0
		3:
			_game_elements["families"] = 3
			_game_elements["twins_amount"] = [3]
			_game_elements["black_holes"] = 2
		_:
			#load_starting_level()
			print("The Game is Over!")
	
	level_data_loaded.emit(_game_elements)

