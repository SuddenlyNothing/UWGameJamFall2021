extends Area2D

onready var label := $CL/M/Label


func _on_SacrificeArea_body_entered(body):
	if not body.is_in_group("player"):
		return
	if body.has_all_items():
		label.text = "You collected all the items!"
	else:
		label.text = "You have not collected all the items"


func _on_SacrificeArea_body_exited(body):
	if not body.is_in_group("player"):
		return
	label.text = ""
