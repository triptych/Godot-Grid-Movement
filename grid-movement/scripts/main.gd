extends Node2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var player = get_node("ObjectLevel/Player")
	var cursor = player.get_node("FacingCursor")
	if Input.is_action_pressed("ui_up"):
		player.take_move_command("up")
		cursor.set_cursor_direction("up")
	elif Input.is_action_pressed("ui_down"):
		player.take_move_command("down")
		cursor.set_cursor_direction("down")
	elif Input.is_action_pressed("ui_left"):
		player.take_move_command("left")
		cursor.set_cursor_direction("left")
	elif Input.is_action_pressed("ui_right"):
		player.take_move_command("right")
		cursor.set_cursor_direction("right")
	elif Input.is_action_pressed("ui_select"):
		cursor.interact()