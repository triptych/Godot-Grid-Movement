# Godot-Grid-Movement
### Simple grid-based movement system utilizing vectors

This is a 2D [Godot Engine](https://godotengine.org/) project that demonstrates an implementation of grid-based, 4-directional, 
top-down movement, similar to what classic RPGs utilize.

## Usage

Because of the relatively low number of files as it's a demonstration, all necessary files are included in the source.
Simply import the project into the Godot Engine's project manager and you can edit it freely. Graphical assets are placeholder-quality
but you are welcome to use them for your own purposes if you wish.

Scripts/grid_movement.gd should be self-sufficient and can be copy pasted into your own project and attached to any KinematicBody2D object. Make sure this object is properly snapped into place.

## Completed Features

* main scene built using tileset with tiles that have simple collisions.
* main scene retrieves keyboard input and sends it to connected Player node via a function.
* Player scene constructed seperately as a KinematicBody2D and instanced as a node of "main".
* When Player receives a directional input command, it will match Player's direction variable to that input.
* If Player receives a directional input command, the commanded movement would not collide, and the Player is not already moving, the Player initiates movement, setting remaining_steps to the cell size in pixels divided by the step distance. If there is a remainder in this division, it is stored in step_remainder and used to determine how far the Player should continue moving to "snap" to the grid.
* Each fixed_process cycle the Player is moving, the delta time is added to the move_timer variable. If this variable equals or exceeds step_delay, a "step" is made, moving the Player by its current move_vector and decrementing remaining_steps
* move_vector stores a Vector2 that determines which direction and to what extent the Player moves for each "step" while movement is active. The amount of time between each "step" and the number of coordinates jumped each "step" of the movement is determined by instance variables of Player.
* If the number of steps remaining is at or below 0, and step_remainder is 0 indicating that there is no remainder to handle, movement will be ended, resetting variables and opening Player to new input commands.
* If there is a step_remainder and the number of steps remaining is <= 0, the script attempts an overflow vector movement to compensate.
* Player has a child StaticBody2D node that acts as a cursor pointing out the adjacent tile for the Player's current direction. Its position is recalibrated when the Player's direction changes from input.
* Objects are children of different YSort nodes which act as layers, which means that within those layers they will draw in front of or behind other objects based on their y position.
* The facing cursor will search for any overlapping physics bodies, and if found, then checks if they are in the "Interactable" group. If so, that object's on_interact() function will be run.

## To Do

* Make compensation more reliable. While the Player doesn't ever move into a cell with a collision, they can appear askew of the grid if cell_size is not divisible by step_distance.
* Rework into a queue system to allow the user to send an array of movement commands to be run one at a time. May make above issue easier to fix.
