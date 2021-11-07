tool
extends Polygon2D

export(String) var room_name : String = ""

# Need this so the collision polygon doesn't have its shape reset.
func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = polygon

# Helper function to adjust polygons.
func set_polygon(points : PoolVector2Array) -> void:
	$Area2D/CollisionPolygon2D.polygon = points
	.set_polygon(points)

# Calls RoomNameDisplay to display the given room name.
func _on_Area2D_body_entered(body):
	if not body.is_in_group("player"):
		return
	get_tree().call_group("room_name_display", "display_name", room_name)
