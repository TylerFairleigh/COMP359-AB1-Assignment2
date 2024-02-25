extends Node

var numberOfPiles:int = 4
var matchMin:int = 1
var matchMax:int = 5
var selected_pile:int = -1

var ongoingGame:bool = false
var player_turn:bool = false # Keeps track of whose turn it is, player's true if true, opponent's turn otherwise

var gameArray:Array = [] # Keeps track of the current number of piles and matches per pile, stored in an array

func _ready():
	_start_round()
	MatchUI.reset_ui_state()
	_game_logic()

# Create a game with a set number of piles and number of matches in each pile
# The maximum values for piles and matches are declared at the top of this file
# Will return an array, where each index corresponds to a pile and its value the number of matches
func _create_game():
	var piles = []
	for i in range(numberOfPiles):
		var pile = randi_range(matchMin, matchMax)
		piles.append(pile)
	return piles

func _start_round():
	# Create the corresponding array for the pile and match sizes
	gameArray = _create_game()
	# Randomly choose who goes first
	player_turn = randi() % 2
	ongoingGame = true

func _game_logic():
	print("Current game space is " + str(gameArray))
	print("Players turn: " + str(player_turn))
	# If the array is empty, the game should be over.
	if (game_is_over()):
		return
	
	if !player_turn:
		MatchUI.toggle_finish_button(false)
		_ai_make_choice()
		# ADD IN TIMER SO ITS NOT INSTANT AND ALSO SOUND EFFECT
		selected_pile = -1
		player_turn = !player_turn
		if (game_is_over()):
			return

func game_is_over():
	var foo = 0
	for pile in range(gameArray.size()):
		if gameArray[pile] < 1:
			foo += 1
	if foo == gameArray.size():
		ongoingGame = false
		if player_turn:
			print("You lose!")
		else:
			print("You win!")
		return true
	return false

func _ai_make_choice():
	# Get the current nim-sum of the game space
	var nimSum = _get_nim_sum(gameArray)
	# Get a possible move which will make the nim sum = 0
	for pile in range(gameArray.size()):
		if gameArray[pile] >= 0:
			# Get new nim sum after removing which would result from removing matches from pile which would be a winning move
			var currentSum = nimSum ^ gameArray[pile]
			# If winning move is valid, do winning move (ie. make nim sum = 0)
			if currentSum < gameArray[pile]:
				# Calculate the actual number of matches to remove to get nim-sum = 0
				# For example, if currentSum = 0 for the pile, we should remove all matches from that pile since (array[pile] - currentSum) is simply number of matches in the pile
				var toRemove = gameArray[pile] - currentSum
				if toRemove > 0: # Cannot remove 0 matches
					MatchUI.remove_matches(pile, toRemove)
					gameArray[pile] -= toRemove
					print("Winning move: " + str(toRemove) + " matches removed from pile " + str(pile + 1))
					return
	# If in losing position, make a random move
	_random_move()
	return 

# Get the current nim sum
func _get_nim_sum(array) -> int:
	var nimSum = 0
	# Calculates the nim sum of the current game space by taking the exclusive OR of the sum of piles
	# Using XOR is essentially doing binary addition with no carry
	for pile in array:
		nimSum = pile ^ nimSum # ^ represents bitwise XOR
	return nimSum

# Simply chooses a random pile and chooses a random amount of matches to remove (Cannot remove 0 matches)
func _random_move():
	var index = -1
	if gameArray[index] < 1:
		index = randi_range(0, gameArray.size() - 1) # Needs to be (array size - 1) so that it references the correct index 
	var remove = randi_range(1, gameArray[index]) # Calculate a random number of matches to remove, minimum number allowable to remove is 1
	gameArray[index] -= remove
	MatchUI.remove_matches(index, remove)
	print(str(remove) + " matches removed from pile " + str(index + 1))

func match_pressed(match_pile:int):
	selected_pile = match_pile
	gameArray[match_pile] -= 1

func restart_game():
	selected_pile = -1
	ongoingGame = false
	player_turn = false
	MatchUI.reset_ui_state()
	_start_round()
	_game_logic()
