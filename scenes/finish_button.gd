extends Button

func _ready():
	self.visible = false

func _on_pressed():
	MatchController.player_turn = false
	MatchController._game_logic()
