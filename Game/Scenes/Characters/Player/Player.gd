extends KinematicBody2D
class_name Player

export(float) var move_speed : float = 100

onready var flip := $Flip

var input : Vector2 = Vector2()


func _process(delta : float) -> void:
	_get_input()
	_set_facing(input.x)


func _physics_process(delta : float) -> void:
	move_and_slide(input * move_speed)

# Sets the x scale of the flip node to match the given x_dir.
func _set_facing(x_dir : int) -> void:
	if x_dir == 0:
		return
	if x_dir != flip.scale.x:
		flip.scale.x *= -1

# Sets input to player input.
func _get_input() -> void:
	input = Vector2()
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input = input.normalized()

# Detects items and collects them
func _on_Detector_area_entered(area : Area2D) -> void:
	if not area.is_in_group("item"):
		return
	get_tree().call_group("hud", "collect_item", area.collect().item_name)
