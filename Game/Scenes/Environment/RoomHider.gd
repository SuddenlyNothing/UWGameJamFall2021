tool
extends Polygon2D

onready var t := $Tween

var fade_out_duration : float = 0.2
var fade_in_duration : float = 0.2

# Sets the polygon for DetectPlayer CollisionPolygon2D
func _ready() -> void:
	if not Engine.editor_hint:
		show()
	$DetectPlayer/CollisionPolygon2D.polygon = polygon


func set_polygon(value : PoolVector2Array) -> void:
	polygon = value
	$DetectPlayer/CollisionPolygon2D.polygon = value

# Fade out when player enters area
func _on_DetectPlayer_area_entered(area : Area2D) -> void:
	if not area.is_in_group("player_detector"):
		return
	t.remove_all()
	t.interpolate_property(self, "color:a", 1, 0, fade_out_duration)
	t.start()

# Fade in when player exits area
func _on_DetectPlayer_area_exited(area : Area2D) -> void:
	if not area.is_in_group("player_detector"):
		return
	t.remove_all()
	t.interpolate_property(self, "color:a", 0, 1, fade_in_duration)
	t.start()
