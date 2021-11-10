extends Enemy

onready var shadow_hand_states := $ShadowHandStates
onready var sight_ray := $SightRay
onready var arm := $N/Arm
onready var hand_sprite := $Sprite
onready var start_pos := position
onready var retreat_timer := $RetreatTimer
onready var label := $Label

var velocity := Vector2()
var acceleration : float = 500.0
var retreat_acceleration : float = 7000.0
var max_move_speed : float = 500.0
var max_retreat_speed : float = 1400.0
onready var max_move_speed_squared = max_move_speed * max_move_speed
onready var max_retreat_speed_squared = max_retreat_speed * max_retreat_speed
var ray_offset : float = 500.0 # Used to make sure the ray isn't hitting the wall it's in

var is_player_in_sight : bool = false


func _ready() -> void:
	arm.points[0] = start_pos
	arm.points[1] = start_pos


func _process(delta : float) -> void:
	label.text = shadow_hand_states.state


func accelerate_to_start(delta : float) -> void:
	velocity += (position.direction_to(start_pos) * retreat_acceleration - velocity) * delta
#	velocity += position.direction_to(start_pos) * retreat_acceleration * delta
	if velocity.length_squared() > max_retreat_speed_squared:
		velocity = velocity.normalized() * max_retreat_speed


func accelerate_to_player(delta : float) -> void:
	velocity += (position.direction_to(player.position) * acceleration - velocity) * delta
#	velocity += position.direction_to(player.position) * acceleration * delta
	if velocity.length_squared() > max_move_speed_squared:
		velocity = velocity.normalized() * max_move_speed


func apply_velocity(delta : float) -> void:
	position += velocity * delta
	hand_sprite.rotation = start_pos.direction_to(position).angle()
	arm.points[1] = position


func is_player_in_ray() -> bool:
	sight_ray.position = position.direction_to(player.position) * ray_offset
	sight_ray.cast_to = player.position - sight_ray.global_position
	sight_ray.force_raycast_update()
	if sight_ray.is_colliding():
		if sight_ray.get_collider() == player:
			return true
	return false


func is_in_start_pos_range() -> bool:
	return position.distance_squared_to(start_pos) <= 600.0


func reset_position() -> void:
	position = start_pos
	arm.points[1] = start_pos


func _on_Sight_body_entered(body):
	if not body.is_in_group("player"):
		return
	is_player_in_sight = true


func _on_Sight_body_exited(body):
	if not body.is_in_group("player"):
		return
	is_player_in_sight = false


func _on_RetreatTimer_timeout():
	if detected:
		shadow_hand_states.call_deferred("set_state", "retreat")
	if is_player_in_sight:
		if is_player_in_ray():
			shadow_hand_states.call_deferred("set_state", "attack")
			return
	shadow_hand_states.call_deferred("set_state", "retreat")


func _on_Hitbox_body_entered(body):
	if not body.is_in_group("player"):
		return
	.show_lose_screen()
