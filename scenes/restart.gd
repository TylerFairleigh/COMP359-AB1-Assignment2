extends Button

func _ready():
	self.visible = false

func _on_pressed():
	self.visible = false;
	MatchUI.label.label_update("Players turn")
	MatchController.restart_game()
