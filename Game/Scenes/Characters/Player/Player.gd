extends KinematicBody2D
class_name Player

export(float) var move_speed : float = 500

onready var flip := $Flip
onready var flashlight := $FlashLight
onready var light_cast := $LightCast
onready var light_area_collision := $FlashLight/LightArea/CollisionPolygon2D
onready var animated_sprite := $Flip/AnimatedSprite
onready var footstep_sfx := $FootstepSFX

var light_entered_enemies = {}
var light_detected_enemies = {}

var input : Vector2 = Vector2()


func _ready() -> void:
	flashlight.show()
	flashlight.rotation = get_local_mouse_position().angle()


func _process(delta : float) -> void:
	_get_input()
	_set_facing()
	_set_anim()
	_set_flashlight_dir()


func _physics_process(delta : float) -> void:
	move_and_slide(input * move_speed)
	_check_light_entered_enemies()
	_check_light_detected_enemies()

# Sets the x scale of the flip node to match the given x_dir.
func _set_facing() -> void:
	if sign(get_local_mouse_position().normalized().x) != sign(flip.scale.x):
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
	light_detected_enemies.erase(area)
	area.undetected()

# Check if any of the enemies detected by the area are
# actually in the light.
# Move to light_detected_enemies if true.
func _check_light_entered_enemies() -> void:
	for enemy in light_entered_enemies:
		if _is_enemy_corners_visible(enemy):
			light_entered_enemies.erase(enemy)
			light_detected_enemies[enemy] = 1
			enemy.detected()

# Check if the detected enemies are still visible.
# If not, return them to light_entered.
func _check_light_detected_enemies() -> void:
	for enemy in light_detected_enemies:
		if not _is_enemy_corners_visible(enemy):
			light_detected_enemies.erase(enemy)
			light_entered_enemies[enemy] = 1
			enemy.undetected()

# Checks if the enemy corners are visible.
func _is_enemy_corners_visible(enemy : Enemy) -> bool:
	var light_poly = _polygon_with_offset(light_area_collision.polygon,
		light_area_collision.global_position, light_area_collision.global_rotation)
	var intersecting_polys = Geometry.intersect_polygons_2d(enemy.get_corners(), light_poly)
	for poly in intersecting_polys:
		var j = 0
		while j < poly.size():
			light_cast.cast_to = poly[j] - light_cast.global_position
			light_cast.force_raycast_update()
			if light_cast.is_colliding():
				var collider = light_cast.get_collider()
				if collider == enemy:
					light_cast.clear_exceptions()
					return true
				if collider is Enemy:
					# Adds exception if colliding with another enemy.
					# This should be removed if the enemy has a light occluder.
					light_cast.add_exception(collider)
					continue
			j += 1
	light_cast.clear_exceptions()
	return false

## Checks if point is inside light area collision polygon.
#func _is_point_inside_light_area(p : Vector2) -> bool:
#	var polygon = _polygon_with_offset(light_area_collision.polygon,
#		light_area_collision.global_position, flashlight.rotation)
#	return Geometry.is_point_in_polygon(p, polygon)
#
## Checks if point is intersecting light area collision polygon.
#func _is_polygon_intersecting_light_area(poly : PoolVector2Array) -> bool:
#	var polygon = _polygon_with_offset(light_area_collision.polygon,
#		light_area_collision.global_position, flashlight.rotation)
#	return not Geometry.intersect_polygons_2d(polygon, poly).empty()


func _polygon_with_offset(poly : PoolVector2Array, offset : Vector2,
	rot : float = 0) -> PoolVector2Array:
		for i in poly.size():
			poly[i] = poly[i].rotated(rot)
			poly[i] += offset
		return poly


func _set_anim() -> void:
	var mouse_angle = get_local_mouse_position().angle()
	if mouse_angle >= -0.25 * PI and mouse_angle <= 0.25 * PI:
		animated_sprite.play("walk_horizontal")
	elif mouse_angle >= -0.75 * PI and mouse_angle <= -0.25 * PI:
		animated_sprite.play("walk_up")
	elif mouse_angle >= 0.75 * PI or mouse_angle <= -0.75 * PI:
		animated_sprite.play("walk_horizontal")
	else:
		animated_sprite.play("walk_down")
	if input == Vector2():
		animated_sprite.stop()
		animated_sprite.frame = 3
	
#	elif input.x != 0:
#		animated_sprite.play("walk_horizontal")
#	else:
#		if input.y < 0:
#			animated_sprite.play("walk_up")
#		else:
#			animated_sprite.play("walk_down")


func _on_AnimatedSprite_frame_changed():
	if animated_sprite.is_playing():
		match animated_sprite.frame:
			1:
				footstep_sfx.play()
			3:
				footstep_sfx.play()
