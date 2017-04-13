extends StaticBody2D

var player
var tile_size
var cursor_pos

func _ready():
	player = get_parent()
	tile_size = player.get_tile_size()
	cursor_pos = {
		"up":    Vector2( tile_size , -tile_size ),
		"down":  Vector2( tile_size , tile_size*3 ),
		"left":  Vector2( -tile_size , tile_size ),
		"right": Vector2( tile_size*3 , tile_size )
	}
	set_cursor_direction( player.get_direction() )

func set_cursor_direction(dir):
	if cursor_pos.has(dir):
		set_pos( cursor_pos[dir] )
	else:
		print("ERROR: sent invalid direction to set_cursor_direction()")
