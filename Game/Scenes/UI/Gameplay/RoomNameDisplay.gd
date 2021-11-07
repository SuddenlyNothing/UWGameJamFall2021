extends CanvasLayer

onready var room_label := $M/RoomLabel
onready var t := $Tween


func display_name(room_name : String) -> void:
	room_label.text = room_name
	t.remove_all()
	t.interpolate_property(room_label, "modulate:a", 0, 1, 0.2)
	t.interpolate_property(room_label, "modulate:a", 1, 0, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 2)
	t.start()
