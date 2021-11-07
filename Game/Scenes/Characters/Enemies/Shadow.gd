extends KinematicBody2D

enum {
	IDLE,
	ROAM,
	CHASE,
	RETREAT
}

export var MAX_SPEED = 50
export var ACCELERATION = 200
export var FRICTION = 500

var state = IDLE
var velocity = Vector2.ZERO

onready var enemySightArea = $EnemySightArea

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

		ROAM: pass

		CHASE:
			var player = enemySightArea.player
			if player:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, delta * ACCELERATION)

		RETREAT: pass

	velocity = move_and_slide(velocity)

func seek_player():
	# Transform such that the shadow "stretches" toward player and stays rooted in the wall
	if enemySightArea.player_in_sight():
		state = CHASE
