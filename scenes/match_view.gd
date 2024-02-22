extends PanelContainer

const match_scene = preload("res://scenes/match.tscn")

@onready var pile_1 = $"VBoxContainer/Pile 1"
@onready var pile_2 = $"VBoxContainer/Pile 2"
@onready var pile_3 = $"VBoxContainer/Pile 3"
@onready var pile_4 = $"VBoxContainer/Pile 4"
@onready var finish = $"../finish"
var pile_counter_set = MatchController.pile_counters

func _ready():
	reset_ui_state()

func reset_ui_state():
	# Toggling off the container which makes a more smooth
	# reset apperance due to the time out.
	self.visible = false
	var match_counter = 1
	var piles = {"pile_1": pile_1, "pile_2": pile_2, "pile_3": pile_3, "pile_4": pile_4}
	
	# Remove any existing matches
	for pile in piles.values():
		for pile_matches in pile.get_children():
			pile_matches.queue_free()
			# This fixes the case when the matches arent free yet
			# which results in godot giving another name.
			await get_tree().create_timer(0.01).timeout
	
	for pile_name in pile_counter_set:
		for i in range(pile_counter_set[pile_name]):
			var match_scene_instance = match_scene.instantiate()
			match_scene_instance.name = "Match_%s" % (match_counter)
			var pile_var = piles[pile_name]
			pile_var.add_child(match_scene_instance)
			match_counter += 1
	self.visible = true


func reset_state():
	MatchController.reset_logic()
	reset_ui_state()
