extends Area2D

export(String, FILE, "*.tscn") var next_scene

onready var label := $CL/M/Label


func _on_SacrificeArea_body_entered(body):
	if not body.is_in_group("player"):
		return
	var hud_group = get_tree().get_nodes_in_group("hud")
	assert(hud_group.size() == 1, "There are too few or too many hud nodes in the scene")
	var hud : HUD = hud_group[0]
	if hud.has_all_items():
		Global.goto_scene(next_scene)
	else:
		label.text = "Return with all the items\nto appease the closet demon"


func _on_SacrificeArea_body_exited(body):
	if not body.is_in_group("player"):
		return
	label.text = ""
