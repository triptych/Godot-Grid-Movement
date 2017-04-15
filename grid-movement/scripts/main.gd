extends Node2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var player = get_node("ObjectLevel/Player")
	var cursor = player.get_node("FacingCursor")
	if Input.is_action_pressed("ui_up"):
		player.take_move_command("up")
	elif Input.is_action_pressed("ui_down"):
		player.take_move_command("down")
	elif Input.is_action_pressed("ui_left"):
		player.take_move_command("left")
	elif Input.is_action_pressed("ui_right"):
		player.take_move_command("right")
	if Input.is_action_pressed("ui_select"):
		cursor.interact()