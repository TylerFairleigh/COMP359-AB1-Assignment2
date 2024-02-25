extends PanelContainer

const match_scene = preload("res://scenes/match.tscn")

@onready var pile_1 = $"VBoxContainer/Pile 1"
@onready var pile_2 = $"VBoxContainer/Pile 2"
@onready var pile_3 = $"VBoxContainer/Pile 3"
@onready var pile_4 = $"VBoxContainer/Pile 4"
@onready var finish = $"../finish"

func _ready():
	reset_ui_state()

func _process(delta):
	if (MatchController.player_turn and (MatchController.selected_pile != -1)):
		finish.visible = true
	else:
		finish.visible = false

func reset_ui_state():
	self.visible = false
	var pile_counter = 0
	var match_counter = 1
	var piles = {"pile_1": pile_1, "pile_2": pile_2, "pile_3": pile_3, "pile_4": pile_4}

	await remove_existing_matches(piles)
	
	for pile_name in piles:
		for _i in range(MatchController.gameArray[pile_counter]):
			var match_scene_instance = match_scene.instantiate()
			match_scene_instance.name = "Match_%s" % match_counter
			piles[pile_name].add_child(match_scene_instance)
			match_counter += 1
		pile_counter += 1

	self.visible = true

func remove_existing_matches(piles):
	for pile in piles.values():
		for pile_matches in pile.get_children():
			pile_matches.queue_free()
			# This fixes the case when the matches arent free yet
			# which results in godot giving another name.
			await get_tree().create_timer(0.01).timeout

func reset_state():
	MatchController.reset_player_turn()
	MatchController.reset_logic()
	reset_ui_state()

func _on_finish_pressed():
	MatchController.valid_match_array.clear()
	MatchController.player_turn = false
	MatchController.player_active = false
	MatchController.bot_move()
