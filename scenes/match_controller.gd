extends PanelContainer

@onready var matches = [$"VBoxContainer/Pile 1/Match_1", $"VBoxContainer/Pile 2/Match_2", $"VBoxContainer/Pile 2/Match_3", $"VBoxContainer/Pile 3/Match_4", $"VBoxContainer/Pile 3/Match_5", $"VBoxContainer/Pile 3/Match_6", $"VBoxContainer/Pile 4/Match_7", $"VBoxContainer/Pile 4/Match_8", $"VBoxContainer/Pile 4/Match_9", $"VBoxContainer/Pile 4/Match_10", $"VBoxContainer/Pile 4/Match_11"]
@onready var finish_button = $finish

var pile_counters = {"pile_1": 1, "pile_2": 2, "pile_3": 3, "pile_4": 5}
var pile_counter_max = [1, 3, 6, 11]
var match_full_count = 0
var player_turn = true
var match_number:int
var valid_match_array

func _ready():
	valid_match_array = []
	match_number = 0
	for match_count in pile_counters:
		match_full_count += pile_counters[match_count]
	reset_player_turn()

func make_range():
	valid_match_array.clear()
	for i in range(len(pile_counter_max) - 1):
		if match_number > pile_counter_max[i] and match_number <= pile_counter_max[i + 1]:
			valid_match_array = range(pile_counter_max[i] + 1, pile_counter_max[i + 1] + 1)
			break
	print(valid_match_array)

func reset_player_turn():
	valid_match_array.clear()
	for i in match_full_count:
		valid_match_array.append(i)

func reset_logic():
	reset_player_turn()

func _on_match_pressed():
	player_turn = false
