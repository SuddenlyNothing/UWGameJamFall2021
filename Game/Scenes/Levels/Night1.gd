extends Node2D

onready var player := $Player


func _ready() -> void:
	assert(position == Vector2(), "The position of the root node needs to be (0, 0).")
	get_tree().call_group("needs_player", "set_player", player)
