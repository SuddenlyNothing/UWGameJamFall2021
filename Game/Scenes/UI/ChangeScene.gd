extends ButtonSFX
class_name ChangeScene

export(String, FILE, "*.tscn") var next_scene

func _ready() -> void:
	self.connect("pressed", self, "_on_ChangeScene_pressed")


# changes scene to next_scene
func _on_ChangeScene_pressed():
	Global.goto_scene(next_scene)
