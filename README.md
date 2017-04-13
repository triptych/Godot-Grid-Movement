# Godot-Grid-Movement
### Simple grid-based movement system utilizing vectors

This is a 2D [Godot Engine](https://godotengine.org/) project that demonstrates an implementation of grid-based, 4-directional, 
top-down movement, similar to what classic RPGs utilize.

## Usage

Because of the relatively low number of files as it's a demonstration, all necessary files are included in the source.
Simply import the project into the Godot Engine's project manager and you can edit it freely. Graphical assets are placeholder-quality
but you are welcome to use them for your own purposes if you wish.

## Completed Features

* main scene built using tileset with tiles that have simple collisions.
* main scene retrieves keyboard input and sends it to connected Player node via a function.
* Player scene constructed seperately as a KinematicBody2D and instanced as a node of "main".
* When Player receives a directional input command, it will match Player's direction variable to that input.
* If Player receives a directional input command, the commanded movement would not collide, and the Player is not already moving,
the Player initiates movement, setting the remaining number of moves to the tile size in pixels.
* Each fixed_process cycle the Player is moving, the delta time is added to the moveTimer variable. If this variable*100 equals or exceeds
the STEP_SPEED constant, a "step" is made, moving the Player by its current moveVector and decreasing the amount the vector moves from
the remaining number of moves.
* moveVector stores a Vector2 that determines which direction and to what extent the Player moves for each "step" while movement is active. 
The amount of time between each "step" and the number of coordinates jumped each "step" of the movement is determined 
by constants in Player.
* If the number of moves remaining is at or below 0, movement will be ended, resetting variables and opening Player to new input commands.
* Player has a child StaticBody2D node that acts as a cursor pointing out the adjacent tile for the Player's current direction.
Its position is recalibrated when the Player's direction changes from input.

## To Do

* Tie z-level/draw order to y position so that objects with a height greater than the tile size will appear above or below
tiles/other objects properly.
* Create objects that will "activate" when the AdjacentTile cursor is hovering over them
* Compensate for the remainder when TILE_SIZE is not divisible by STEP_DISTANCE
