extends TileMap

onready var door_tiles_render := $DoorTilesRender


func _ready() -> void:
	for i in get_used_cells():
		door_tiles_render.set_cell(i.x, i.y, 0, false, false,
			false, get_cell_autotile_coord(i.x, i.y))
		


#func set_cell(x : int, y : int, tile : int, flip_x : bool = false,
#	flip_y : bool =false, transpose : bool = false, autotile_coord : Vector2 = Vector2(0, 0)) -> void:
#	print("set_cell")
#	$DoorTilesRender.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
#	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
