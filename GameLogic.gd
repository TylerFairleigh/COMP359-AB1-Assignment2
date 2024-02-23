extends Node

var pileMin = 3
var pileMax = 3 # Declare a strict maximum
var matchMin = 1
var matchMax = 8
var gameArray # Keeps track of the current number of piles and matches per pile, stored in an array
var playerTurn # Keeps track of whose turn it is, player's true if true, opponent's turn otherwise
var ongoingGame = false

# Create a game with a set number of piles and number of matches in each pile
# The maximum values for piles and matches are declared at the top of this file
# Will return an array, where each index corresponds to a pile and its value the number of matches
func _create_game():
	var piles = []
	var numberOfPiles = randi_range(pileMin, pileMax)
	#print("Number of piles: " + numberOfPiles)
	#piles = [numberOfPiles]
	for pile in numberOfPiles:
		piles.append(randi_range(matchMin, matchMax))
	return piles

func _start_round():
	# Create the corresponding array for the pile and match sizes
	gameArray = _create_game()
	# Randomly choose who goes first
	if randi() % 2:
		playerTurn = true
	else:
		playerTurn = false
	ongoingGame = true

func _ready():
	_start_round()

func _process(_delta):
	if ongoingGame:
		_game_logic(gameArray)

func _game_logic(array):
	# Clean up array every time a pile is emptied, remove its index from the array
	_shrink_array(array)
	# If the array is empty, the game should be over.
	# Whoever makes the last move is the winner
	if array.is_empty():
		ongoingGame = false
		if playerTurn:
			print("You lose!")
		else:
			print("You win!")
		return
	print("Current game space is " + str(array))
	if playerTurn:
		# the player's turn to take matches))
		print("Player's turn")
		# Insert player control here and remove _random_move()
		_player_make_choice(array)
		
		# Remove this function once player choice is implemented
		_random_move(array)
		
		playerTurn = false
	else:
		# opponent's turn to take matches
		print("Opponent's turn")
		_ai_make_choice(array)
		playerTurn = true

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
