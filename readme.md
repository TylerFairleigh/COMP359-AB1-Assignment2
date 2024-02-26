
# COMP359 - Assignment 2 - Game of Nim
<p>This project creates the game of Nim inside of the Godot engine.<br>
To rules are as follows:<br>

> - You can only choose to remove matches from one pile per turn,
> - You can remove as many matches as you want, but you cannot remove none,  
> - The winner of the game is whoever made the last move (opposite of misère version).

The player is pit up against a computer opponent which will choose the optimal solution.<br>
Finding the Nim-Sum ensures victory so long as you make the nim-sum zero as a result of your move.</p>

# How do we keep track of the game space?  
<p>Keeping track of the game space was done through the use of an array.<br>
Each index of the array corresponds to a pile. The value associated at that index represents the number of matches in the pile.</p>
<p>For example, if we have an array: [1, 3, 5, 7]  

> - The first pile has 1 match,  
> - The second pile has 3 matches,  
> - The third pile has 5 matches,  
> - The fourth pile has 7 matches. </p>

# How do we calculate the nim-sum?  
We can calculate the nim-sum by summing the binary values for each pile with no carry.  
However, we can note that this is the exclusive or (XOR) of the sum of all piles.  
  
Using a for-loop to iterate through the game space array, for each pile we observe, we take the bitwise XOR of the current nim-sum (which is initialized to 0) with the value associated with the current pile.  
This is done simply by using the bitwise XOR operator which is represented by "^".  
  
``` 
func _get_nim_sum(gameArray) -> int:
	nimSum = 0  
	for pile in gameArray:  
		nimSum = pile ^ nimSum  
	return nimSum  
```
  
Recall that to be in a winning position we have to have a nim-sum which is non-zero as an result of our move.  

# Analyzing _get_nim_sum() run-time
<p>Analyzing the run-time of this algorithm, we can see that we take in the game space array as input, which has size <i>n</i>.<br>
The main operation will be the for-loop, which will iterate through the array linearly. The operations within the for-loop run constant-time.<br>
We can easily say for this algorithm that the run-times are as follows:

> - Worst-Case: *O(n)*
> - Average-Case: *Θ(n)*
> - Best-Case: *Ω(1)*

Due to the nature of the algorithm, the average-case and worst-case scenarios share the same complexity as it always involes interating through the entire array.<br>
The best-case is simply if we pass through an array containing one element.<br>

The space complexity is constant <i>O(1)</i> as we simply return an integer.

# Tying it all together for the opponent's AI  

<p>The first thing we need to do is figure out the nim-sum of the current game space, thus we call our function to get our nim-sum.<br>  
With the nim-sum known, we need to find an optimal solution.</p>
<p>We have to iterate through the game space array using a for-loop. Each iteration, we take the bitwise XOR of the nim-sum of the game space and the number of matches for every pile that gets iterated through, this gives us a new sum.<br>
Each iteration through the array could yield a sum which will result in a winning state, and thus a winning move.<br>
This sum has to be smaller or equal to the number of matches in the pile that is currently being inspected.<br>
If the sum is smaller than the pile size, we can subtract that value from the number of matches in that pile (toRemove = gameArray[pile] - currentSum) to give us the number of matches to remove from the pile to get our appropriate nim-sum.<br>

> For example, if it turns out the sum is zero, this means we should take all matches from that pile to get rid of that pile  
> or, if the sum is 3 and the number of matches in the pile is 7, we should only remove 4 matches from that pile.

If we are able to remove that number of matches from a pile (ie. greater than zero), we update the game array accordingly and that ends the opponent's turn leaving the player in a losing position.</p>
<p>If we did not find a value that gets the state into a winning position, we continue iterating through the game space array until we find a solution that works, or have exhausted the array.</p>
<p>If the opponent is unable to make a move which gets it into the winning position (exhausted the game space array), it can simply only make a move at random as there's no other way for it to make the nim-sum zero.</p>

```
func _ai_make_choice():
	var nimSum = _get_nim_sum(gameArray)
	for pile in range(gameArray.size()):
		if gameArray[pile] > 0:
			var currentSum = nimSum ^ gameArray[pile]
			if currentSum < gameArray[pile]:
				var toRemove = gameArray[pile] - currentSum
				if toRemove > 0:
					MatchUI.remove_matches(pile, toRemove)
					gameArray[pile] -= toRemove
					MatchUI.label.label_update("AI took " + str(toRemove) + " from pile " + str(pile + 1))
					return
	_random_move()
	return 
```

# Analyzing _ai_make_choice() run-time
*Note: We will ignore any possible overhead from updating the UI and focus solely on the actual algorithm of the AI*
<p>Analyzing this algorithm for it's run-time. We can see that our input is simply the game space array, which we can assume has size <i>n</i>.<br>
We know that the function to find the nim-sum runs linear time.<br>
The for-loop contains operations which only run constant-time. Note that if we are able to find a solution within the for-loop, it will return from this code block, skipping over the remainder of the function.<br>

The random move function is as follows:
```
func _random_move():
	var index = randi_range(0, gameArray.size() - 1)
	while gameArray[index] < 1:
		index = randi_range(0, gameArray.size() - 1) # Needs to be (array size - 1)
	var remove = randi_range(1, gameArray[index])
	gameArray[index] -= remove
	MatchUI.remove_matches(index, remove)
	MatchUI.label.label_update("AI took " + (str(remove)) + " from pile " + str(index + 1))
```

Assuming that the random function built into Godot is constant, the result of executing this function would have a run-time complexity which is also constant.
Due to there being instances of where we may not need to inspect every element of the game array, possibly terminating early, we can say the for-loop will run *m* times, where 0 < *m* < *n*.<br>
Keeping this in-mind, we can list our time complexities:

> - Worst-Case: *O(n)*
> - Average-Case: *Θ(m)*
> - Best-Case: *Ω(1)*

The worst-case involves exhausting the game array, either making a choice at the last element of the game array, or not being in the winning position and making a random move after exhausting the for-loop. <br>
The average-case is simply the case where we may not have to go through every element in the game array to make a choice. <br>
The best-case is if we are able to make a winning move on the first iteration of the for-loop. <br>

Due to the array remaining the same size no matter what, the space complexity remains constant, thus *O(1)*.
</p>

# References

tanchongmin. (2021, April 29). Solving the Game of Nim. Retrieved from https://delvingintotech.wordpress.com/2021/04/29/solving-the-game-of-nim/  
Godot Engine. (n.d.). Godot Engine 4.2 documentation in English. Godot Engine. https://docs.godotengine.org/en/stable/index.html