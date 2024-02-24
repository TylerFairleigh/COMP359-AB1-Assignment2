extends Node

@onready var matches = [$"VBoxContainer/Pile 1/Match_1", $"VBoxContainer/Pile 2/Match_2", $"VBoxContainer/Pile 2/Match_3", $"VBoxContainer/Pile 3/Match_4", $"VBoxContainer/Pile 3/Match_5", $"VBoxContainer/Pile 3/Match_6", $"VBoxContainer/Pile 4/Match_7", $"VBoxContainer/Pile 4/Match_8", $"VBoxContainer/Pile 4/Match_9", $"VBoxContainer/Pile 4/Match_10", $"VBoxContainer/Pile 4/Match_11"]
@onready var turn_label = $turn_label

var pileMin = 4
var pileMax = 4 # Declare a strict maximum
var matchMin = 1
var matchMax = 5
var gameArray # Keeps track of the current number of piles and matches per pile, stored in an array
var player_turn # Keeps track of whose turn it is, player's true if true, opponent's turn otherwise
var ongoingGame = false
var player_active = false
var match_number:int = 3
var match_index_max = [] # Keeps track of the maximum index of a match in each pile
var match_full_count # Keeps track of the total number of matches in the game space
var pile_counters = {"pile_1": 0, "pile_2": 0, "pile_3": 0, "pile_4": 0}
var valid_match_array = [] # Keeps track of the valid range of matches to remove from a pile

# Create a game with a set number of piles and number of matches in each pile
# The maximum values for piles and matches are declared at the top of this file
# Will return an array, where each index corresponds to a pile and its value the number of matches
func _create_game():
	var piles = []
	var numberOfPiles = randi_range(pileMin, pileMax)
	var match_full_count = 0
	for i in range(numberOfPiles):
		var pile = randi_range(matchMin, matchMax)
		match_full_count += pile
		match_index_max.append(match_full_count)
		piles.append(pile)
		pile_counters["pile_" + str(i + 1)] = pile
	return piles

func _start_round():
	# Create the corresponding array for the pile and match sizes
	gameArray = _create_game()
	# Randomly choose who goes first
	if randi() % 2:
		player_turn = true
	else:
		player_turn = false
	ongoingGame = true

func _ready():
	_start_round()

func _process(_delta):
	pass
	# if ongoingGame:
	# 	_game_logic(gameArray)

func _game_logic(array):
	# Clean up array every time a pile is emptied, remove its index from the array
	_shrink_array(array)
	# If the array is empty, the game should be over.
	# Whoever makes the last move is the winner
	if array.is_empty():
		ongoingGame = false
		if player_turn:
			print("You lose!")
		else:
			print("You win!")
		return
	print("Current game space is " + str(array))
	if player_turn:
		# the player's turn to take matches))
		print("Player's turn")

		valid_match_array.clear()
		for i in match_full_count:
			valid_match_array.append(i + 1)
		# Insert player control here and remove _random_move()
		_player_make_choice(array)
		
		# Remove this function once player choice is implemented
		_random_move(array)
		
		player_turn = false
	else:
		# opponent's turn to take matches
		print("Opponent's turn")
		_ai_make_choice(array)
		player_turn = true

# Function to remove indices which contain value 0
func _shrink_array(array):
		for pile in range(array.size() - 1, -1, -1): # Iterates the array from end to start to avoid any index range errors
			if array[pile] == 0:
				array.remove_at(pile) # Remove empty piles from array

# Function to get the player's choice from the UI
func _player_make_choice(array):
	var pile = -1 # initalize a value the player shouldn't be able to choose
	# Keep prompting player to choose a pile until it's a valid choice
	while pile > 0 or pile < gameArray.size():
		print("Choose a pile.")
		pile =  0 # insert function call to get player's selected pile
		return
	var toRemove = 0 # insert function call which returns number of matches player selected
	array[pile] -= toRemove

func _ai_make_choice(array):
	# Get the current nim-sum of the game space
	var nimSum = _get_nim_sum(array)
	# Get a possible move which will make the nim sum = 0
	for pile in range(array.size()):
		# Get new nim sum after removing which would result from removing matches from pile which would be a winning move
		var currentSum = nimSum ^ array[pile]
		# If winning move is valid, do winning move (ie. make nim sum = 0)
		if currentSum < array[pile]:
			# Calculate the actual number of matches to remove to get nim-sum = 0
			# For example, if currentSum = 0 for the pile, we should remove all matches from that pile since (array[pile] - currentSum) is simply number of matches in the pile
			var toRemove = array[pile] - currentSum
			if toRemove > 0: # Cannot remove 0 matches
				array[pile] -= toRemove
				print("Winning move: " + str(toRemove) + " matches removed from pile " + str(pile + 1))
				return
	# If in losing position, make a random move
	_random_move(array)
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
func _random_move(array):
	var index = randi_range(0, array.size() - 1) # Needs to be (array size - 1) so that it references the correct index 
	var remove = randi_range(1, array[index]) # Calculate a random number of matches to remove, minimum number allowable to remove is 1
	array[index] -= remove
	print(str(remove) + " matches removed from pile " + str(index + 1))

func make_range():
	valid_match_array.clear()
	for i in range(len(match_index_max) - 1):
		if match_number > match_index_max[i] and match_number <= match_index_max[i + 1]:
			valid_match_array = range(match_index_max[i] + 1, match_index_max[i + 1] + 1)
			break
