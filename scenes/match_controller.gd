extends PanelContainer

@onready var matches = [$"VBoxContainer/Pile 1/Match_1", $"VBoxContainer/Pile 2/Match_2", $"VBoxContainer/Pile 2/Match_3", $"VBoxContainer/Pile 3/Match_4", $"VBoxContainer/Pile 3/Match_5", $"VBoxContainer/Pile 3/Match_6", $"VBoxContainer/Pile 4/Match_7", $"VBoxContainer/Pile 4/Match_8", $"VBoxContainer/Pile 4/Match_9", $"VBoxContainer/Pile 4/Match_10", $"VBoxContainer/Pile 4/Match_11"]

var player_turn = true
var match_number

func _ready():
	match_number = 0

func _process(delta):
	#var foo = []
	#for match_item in matches:
		#foo.append(match_item.visible)
	print(match_number)

func _on_restart_pressed():
		for match_item in matches:
			match_item.visible = true

func _on_match_pressed():
	player_turn = false

