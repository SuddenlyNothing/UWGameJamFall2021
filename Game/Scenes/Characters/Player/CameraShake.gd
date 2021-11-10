extends Camera2D

onready var shake_timer := $ShakeTimer

var max_offset : float = 10.0
var max_rot : float = 5.0


func _ready() -> void:
	set_process(false)


func shake(duration : float) -> void:
	shake_timer.start(duration)
	set_process(true)


func _process(delta : float) -> void:
	offset = Vector2(randf() * max_offset * 2 - max_offset, randf() * max_offset * 2 - max_offset)
	rotation_degrees = randf() * max_rot * 2 - max_rot


func _on_ShakeTimer_timeout():
	offset = Vector2()
	rotation_degrees = 0
	set_process(false)
