extends Enemy

onready var shadow_hand_states := $ShadowHandStates
onready var sight_ray := $SightRay
onready var arm := $N/Arm
onready var hand_sprite := $Sprite
onready var start_pos := position
onready var retreat_timer := $RetreatTimer
onready var label := $Label
onready var sight_collision := $Sight/CollisionShape2D

var velocity := Vector2()
var steering : float = 0.02
var retreat_steering : float = 0.1
var max_move_speed : float = 500.0
var max_retreat_speed : float = 1400.0
onready var max_move_speed_squared = max_move_speed * max_move_speed
onready var max_retreat_speed_squared = max_retreat_speed * max_retreat_speed
var ray_offset : float = 500.0 # Used to make sure the ray isn't hitting the wall it's in

var is_player_in_sight : bool = false
var difficulty : int = 0 setget set_difficulty

var always_attack : bool = false


func _ready() -> void:
	arm.points[0] = start_pos
	arm.points[1] = start_pos


func _process(delta : float) -> void:
	label.text = shadow_hand_states.state


func accelerate_to_start(delta : float) -> void:
#	velocity += (position.direction_to(start_pos) * retreat_acceleration - velocity) * delta
#	velocity += position.direction_to(start_pos) * retreat_acceleration * delta
	velocity = lerp(velocity, position.direction_to(start_pos) * max_retreat_speed, retreat_steering)


func accelerate_to_player(delta : float) -> void:
#	velocity += (position.direction_to(player.position) * acceleration - velocity) * delta
#	velocity += position.direction_to(player.position) * acceleration * delta
	velocity = lerp(velocity, position.direction_to(player.position) * max_move_speed, steering)


func apply_velocity(delta : float) -> void:
	position += velocity * delta
	hand_sprite.rotation = start_pos.direction_to(position).angle()
	arm.points[1] = position


func is_player_in_ray() -> bool:
	if always_attack:
		return true
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
	set_process(false)
	shadow_hand_states.set_physics_process(false)
	.kill_player()
	get_tree().call_group("shadow_hand", "set_difficulty", 2)


func set_difficulty(dif : int) -> void:
	assert(dif >= 0 and dif <= 2, "wrong difficulty level")
	difficulty = dif
	match dif:
		0: # default
			steering = 0.02
			max_move_speed = 500
			sight_collision.shape.radius = 2500
		1: # medium
			steering = 0.05
			max_move_speed = 1000.0
			sight_collision.shape.radius = 3500
			ray_offset = 700
		2: # impossible
			steering = 0.1
			max_move_speed = 2000.0
			sight_collision.shape.radius = 10000
			ray_offset = 2000


func set_to_attack() -> void:
	always_attack = true
	retreat_timer.stop()
	shadow_hand_states.call_deferred("set_state", "attack")
	is_player_in_sight = true
