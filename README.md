# Godot-Grid-Movement
### Simple grid-based movement system utilizing vectors

This is a 2D [Godot Engine](https://godotengine.org/) project that demonstrates an implementation of grid-based, 4-directional, 
top-down movement, similar to what classic RPGs utilize.

## Usage

Because of the relatively low number of files as it's a demonstration, all necessary files are included in the source.
Simply import the project into the Godot Engine's project manager and you can edit it freely. Graphical assets are placeholder-quality
but you are welcome to use them for your own purposes if you wish.

Scripts/grid_movement.gd should be self-sufficient and can be copy pasted into your own project and attached to any KinematicBody2D object. Make sure this object is properly snapped into place.

## Default Controls

Arrow Keys: Move

Spacebar: Interact

Tab: Toggle noclip

Q: Queue one "up" motion command

A: Queue a series of motion commands representing the directional input of the Konami Code

Z: Queue a series of motion commands as dictionaries, moving slowly to the left one tile then rapidly to the right the next

X: Toggle facing towards current direction, leaving facing at current value or having it match direction

## Completed Features

* main scene built using tileset with tiles that have simple collisions.
* main scene retrieves keyboard input and sends it to connected Player node via a function.
* Player scene constructed seperately as a KinematicBody2D and instanced as a node of "main".
* A grid_movement body has public(exported) variables representing the cell_size of the grid, the movespeed of the body, the direction of the body, and whether the body has an input_lock(can receive manual queue orders, but not input commands).
* When Player receives a directional input command, it will match Player's direction variable to that input.
* If Player receives a directional input command, the commanded movement would not collide, the input lock is disabled, and the Player is not already moving, the Player initiates movement by adding a motion object to the motion_queue.
* Motion objects hold the direction that was passed(defaulting to the Player's direction at the time), the starting position of the motion, the end position of the motion, the speed it was passed(defaulting to the Player's movespeed at the time), and a vector that is run in a move() function each cycle to move Player towards the end point.
* Each fixed_process cycle, the motion_queue is checked for motion objects, and if at least one exists the top motion object is passed to be processed.
* During processing, the motion is checked to discover whether it has reached the end point or whether this cycle's movement will overshoot the end point. If not, the motion's vector will be run through move().
* If so, however, Player is snapped to the end point if they will overshoot, and then the front of the motion_queue is popped, moving on to the next motion in the queue(or emptying it).
* Player has a child Area2D node that acts as a cursor pointing out the adjacent tile for the Player's current facing. Its position will always match the adjacent tile to the Player's current facing.
* Objects are children of different YSort nodes which act as layers, which means that within those layers they will draw in front of or behind other objects based on their y position.
* The facing cursor will search for any overlapping physics bodies, and if found, then checks if they are in the "Interactable" group. If so, that object's on_interact() function will be run.
* The Player can be set to ignore collisions by activating the function noclip_on(), and collisions can be restored by activating noclip_off(). You can also activate toggle_noclip() to toggle between these states, which is demonstrated here with the Tab key.
* You can queue up a motion to be run when it reaches the top of the motion_queue by passing the queue_move_command() function a string representing a direction("up"/"down"/"left"/"right"). It will automatically project itself based on the endpoint of the last motion currently in the queue, or the last motion that was run if it is empty. The motion will be skipped if the script detects it will cause a collision.
* You can also iterate through an array of directional strings by passing that array to the queue_move_commands() function. This will simply perform queue_move_command() for each element in the array.
* queue_move_commands() can also be sent an array of dictionaries which have a "direction" key, but also a "speed" key that allows you to specify a particular speed for a motion command.
* The Player's facing is seperate from their direction, but by default will match it. However, this behavior can be disabled and the facing can be modified separately from the direction. The facing is not used internally to the grid_movement script but could be very useful when referenced outside of it, such as for sprite manipulations.

## To Do

* Implement A* Pathfinding to allow the Player to move to a given position based on a point or another 2D Body object.
