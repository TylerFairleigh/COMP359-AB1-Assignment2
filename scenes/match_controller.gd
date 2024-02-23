extends PanelContainer

@onready var matches = [$"VBoxContainer/Pile 1/Match_1", $"VBoxContainer/Pile 2/Match_2", $"VBoxContainer/Pile 2/Match_3", $"VBoxContainer/Pile 3/Match_4", $"VBoxContainer/Pile 3/Match_5", $"VBoxContainer/Pile 3/Match_6", $"VBoxContainer/Pile 4/Match_7", $"VBoxContainer/Pile 4/Match_8", $"VBoxContainer/Pile 4/Match_9", $"VBoxContainer/Pile 4/Match_10", $"VBoxContainer/Pile 4/Match_11"]
@onready var turn_label = $turn_label

var pile_counters = {"pile_1": 1, "pile_2": 2, "pile_3": 3, "pile_4": 5}
var pile_counter_max = [1, 3, 6, 11]
var match_full_count = 0
var player_turn = true
var player_active = false
var match_number:int
var valid_match_array
var match_array_game = []

func _ready():
	valid_match_array = []
	match_number = 0
	for match_count in pile_counters:
		match_full_count += pile_counters[match_count]
		match_array_game.append(pile_counters[match_count])
	reset_player_turn()
	reset_logic()

func make_range():
	valid_match_array.clear()
	for i in range(len(pile_counter_max) - 1):
		if match_number > pile_counter_max[i] and match_number <= pile_counter_max[i + 1]:
			valid_match_array = range(pile_counter_max[i] + 1, pile_counter_max[i + 1] + 1)
			break

func reset_player_turn():
	player_turn = true
	player_active = false
	valid_match_array.clear()
	for i in match_full_count + 1:
		valid_match_array.append(i)
	TurnLabel.label_change()

func bot_move():
	print("Bots move would go here")
	reset_player_turn()
	
func match_pressed(match_number):
	match_array_game[match_pile_return(match_number)] -= 1

func match_pile_return(match_number):
	if (match_number in [1]):
		return 0
	elif (match_number in [2,3]):
		return 1
	elif (match_number in [4,5,6]):
		return 2
	else:
		return 3

func reset_logic():
	match_array_game.clear()
	match_array_game = [1,2,3,5]
