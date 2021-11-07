extends Area2D

var player = null

func player_in_sight():
	return player != null

func _on_EnemySightArea_body_entered(body:Node):
	player = body

func _on_EnemySightArea_body_exited(body:Node):
	player = null
