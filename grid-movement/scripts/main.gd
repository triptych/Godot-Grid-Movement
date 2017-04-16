extends Node2D

var player
var cursor

func _ready():
	player = get_node("ObjectLevel/Player")
	cursor = player.get_node("FacingCursor")
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta):
	if Input.is_action_pressed("ui_up"):
		player.take_move_command("up")
	elif Input.is_action_pressed("ui_down"):
		player.take_move_command("down")
	elif Input.is_action_pressed("ui_left"):
		player.take_move_command("left")
	elif Input.is_action_pressed("ui_right"):
		player.take_move_command("right")

func _input(event):
	if event.is_action_released("ui_select"):
		cursor.interact()
	elif event.is_action_released("ui_focus_next"):
		player.toggle_noclip()
	elif event.is_action_released("queue_one_motion"):
		player.queue_move_command("up")
	elif event.is_action_released("queue_several_motions"):
		player.queue_move_commands(["up", "up", "down", "down", "left", "right", "left", "right"])