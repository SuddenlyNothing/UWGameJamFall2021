extends Area2D
class_name Enemy

var player

onready var collision_shape := $CollisionShape2D

# Sets player.
# Called by the root node for nodes that are in the "needs_player" group.
func set_player(p) -> void:
	player = p

# Called when player shines light on the body.
func detected() -> void:
	get_tree().call_group("room_name_display", "display_name", name + " detected")

# Called when the player stops shining light on the body.
func undetected() -> void:
	get_tree().call_group("room_name_display", "display_name", name + " undetected")

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
