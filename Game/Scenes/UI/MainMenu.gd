extends Control

func _ready() -> void:
	MusicPlayer.play("title")


func _on_Quit_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_Settings_pressed():
	OptionsMenu.active = true
