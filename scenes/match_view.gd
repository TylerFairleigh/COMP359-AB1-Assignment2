extends PanelContainer

const match_scene = preload("res://scenes/match.tscn")

var pile_1; var pile_2; var pile_3; var pile_4; var finish; var label; var restart; var sound_effect;

# Loads up all the nodes we will need for accessing during the game
func _ready():
	pile_1 = get_tree().root.get_node("main/matches/VBoxContainer/Pile 1")
	pile_2 = get_tree().root.get_node("main/matches/VBoxContainer/Pile 2")
	pile_3 = get_tree().root.get_node("main/matches/VBoxContainer/Pile 3")
	pile_4 = get_tree().root.get_node("main/matches/VBoxContainer/Pile 4")
	finish = get_tree().root.get_node("main/finish")
	restart = get_tree().root.get_node("main/restart")
	label = get_tree().root.get_node("main/turn_label")
	sound_effect = get_tree().root.get_node("main/bot_choice_sound_effect")
	
# Resets the state of the UI and adds in any new matches for the next game
func reset_ui_state():
	self.visible = false
	sound_effect.pitch_scale = 1
	MatchUI.toggle_finish_button(false)
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

# Takes away any existing matches from the game
func remove_existing_matches(piles):
	for pile in piles.values():
		for pile_matches in pile.get_children():
			pile_matches.queue_free()
			# This fixes the case when the matches arent free yet
			# which results in godot giving another name.
			await get_tree().create_timer(0.01).timeout

# Removes a select amount of matches from a pile 
func remove_matches(pile_index:int, amount_of_matches:int):
	var pile_node_array = [pile_1, pile_2, pile_3, pile_4]
	var pile_node_children = pile_node_array[pile_index].get_children()
	for i in range(amount_of_matches):
		if i < len(pile_node_children):
			pile_node_children[i].queue_free()

func toggle_finish_button(state:bool):
	finish.visible = state

func toggle_restart_button(state:bool):
	restart.visible = state

func play_sound_effect():
	sound_effect.play()
