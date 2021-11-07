extends KinematicBody2D
class_name Player

export(float) var move_speed : float = 100

onready var flip := $Flip
onready var flashlight := $FlashLight
onready var light_cast := $LightCast

var light_entered_enemies = {}
var light_detected_enemies = {}


var input : Vector2 = Vector2()


func _ready() -> void:
	flashlight.show()
	flashlight.rotation = get_local_mouse_position().angle()


func _process(delta : float) -> void:
	_get_input()
	_set_facing(input.x)
	_set_flashlight_dir()


func _physics_process(delta : float) -> void:
	move_and_slide(input * move_speed)
	_check_light_entered_enemies()
	

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

# Sets direction of flashlight
func _set_flashlight_dir() -> void:
	flashlight.rotation = lerp_angle(flashlight.rotation,
		(get_local_mouse_position() + Vector2.DOWN * 16).angle(), 0.01)

# Add enemies to a check.
func _on_LightArea_area_entered(area : Area2D) -> void:
	if not area.is_in_group("enemy"):
		return
	light_entered_enemies[area] = 1

# Undetect enemies that exit light.
func _on_LightArea_area_exited(area : Area2D) -> void:
	if not area.is_in_group("enemy"):
		return
	if not area in light_detected_enemies:
		light_entered_enemies.erase(area)
		return
	light_cast.remove_exception(area)
	area.undetected()

# Check if any of the enemies detected by the area are
# actually in the light.
# Move to light_detected_enemies if true.
func _check_light_entered_enemies() -> void:
	for i in light_entered_enemies:
		for j in i.get_corners():
			light_cast.cast_to = j - light_cast.global_position
			light_cast.force_raycast_update()
			if light_cast.is_colliding():
				if light_cast.get_collider() == i:
					light_entered_enemies.erase(i)
					light_detected_enemies[i] = 1
					light_cast.add_exception(i)
					i.detected()
					break
