tool
extends Polygon2D

export(Array, NodePath) var hide_objects := []

onready var t := $Tween


func _ready() -> void:
	$Area2D/CollisionPolygon2D.polygon = polygon
	if not Engine.editor_hint:
		set_visible(false, 0)


func set_polygon(value : PoolVector2Array) -> void:
	polygon = value
	$Area2D/CollisionPolygon2D.polygon = value


func _on_Area2D_body_entered(body):
	if not body.is_in_group("player"):
		return
	set_visible(true)


func _on_Area2D_body_exited(body):
	if not body.is_in_group("player"):
		return
	set_visible(false)


func set_visible(val : bool, dur : float = 0.3) -> void:
	var start_val : float = 0.0 if val else 1.0
	var end_val : float = 1.0 if val else 0.0 
	for i in hide_objects:
		t.interpolate_property(get_node(i), "modulate:a", start_val, end_val, dur)
	t.start()
