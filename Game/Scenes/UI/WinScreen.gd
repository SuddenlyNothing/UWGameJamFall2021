extends Control



export(String, FILE, "*.tscn") var next_level := ""

onready var animated_sprite := $AnimatedSprite
onready var squeak_sfx := $SqueakSFX
onready var pentagram := $AnimatedSprite/Pentagram
onready var t := $Tween
onready var ui := $V
onready var win_music := $WinMusic


func _ready() -> void:
	if next_level == "":
		return
	


func _on_AnimatedSprite_frame_changed():
	if animated_sprite.frame == 15:
		t.interpolate_property(pentagram, "modulate:r", 1, 5, 0.3)
		t.interpolate_property(pentagram, "modulate:r", 5, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN, 0.3)
		t.start()
		squeak_sfx.play()


func _on_SqueakSFX_finished():
	t.interpolate_property(animated_sprite, "modulate:a", 1, 0, 0.3)
	t.start()
	t.interpolate_property(ui, "modulate:a", 0, 1, 0.3)
#	t.start()
	ui.show()
#	yield(t, "tween_all_completed")
	win_music.play()
