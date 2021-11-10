extends Area2D
class_name Enemy

export(String, FILE, "*.tscn") var lose_screen
var player

onready var collision_shape := $CollisionShape2D

var detected := false

# Sets player.
# Called by the root node for nodes that are in the "needs_player" group.
func set_player(p) -> void:
	player = p

# Called when player shines light on the body.
func detected() -> void:
	detected = true

# Called when the player stops shining light on the body.
func undetected() -> void:
	detected = false

# Called by the player in order to check every corner.
# Only works for rectangle collision shape.
# Override if you change the collision shape.
func get_corners() -> PoolVector2Array:
	var corners := PoolVector2Array()
	var shape_extents : Vector2 = collision_shape.shape.extents
	corners.append(collision_shape.global_position - shape_extents)
	corners.append(collision_shape.global_position + Vector2(shape_extents.x, -shape_extents.y))
	corners.append(collision_shape.global_position + shape_extents)
	corners.append(collision_shape.global_position + Vector2(-shape_extents.x, shape_extents.y))
	return corners


func kill_player() -> void:
	get_tree().call_group("player", "kill")
