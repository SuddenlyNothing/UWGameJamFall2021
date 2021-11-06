extends TextureProgress

signal no_time

onready var timer := $Timer
var timer_total_time : float


func _ready() -> void:
	set_process(false)


func _process(delta : float) -> void:
	_set_progress_value()

# Sets the value of the progress texture.
func _set_progress_value() -> void:
	value = timer.time_left / timer_total_time

# Adds given amount of time to the timer.
# Constrain determines whether or not to allow the added amount to
# go past the original wait time. True = don't allow.
func add_time(amount : float, constrain : bool = true) -> void:
	var new_time : float = timer.time_left + amount
	if new_time > timer_total_time:
		if constrain:
			new_time = timer_total_time
		else:
			timer_total_time = new_time
	timer.start(new_time)

# Starts the time to the given amount.
func start_timer(amount : float) -> void:
	set_process(true)
	timer_total_time = amount
	timer.start(amount)


func _on_Timer_timeout():
	emit_signal("no_time")
