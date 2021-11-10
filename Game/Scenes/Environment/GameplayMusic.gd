extends Node

export(float, 20, 360) var game_duration := 60.0

onready var timer := $Timer
onready var music_a := $MusicA
onready var music_b := $MusicB
onready var music_c := $MusicC
onready var music_d := $MusicD
onready var scared_breathing := $ScaredBreathing

var time_ind = 0
var time_queue = [0, 0]


func _ready() -> void:
	MusicPlayer.stop_all()
	start(game_duration)


func start(time : float) -> void:
	time_ind = 0
	music_a.play()
	music_b.stop()
	music_c.stop()
	music_d.stop()
	timer.start(time / 4.0)
	time_queue[0] = time / 4.0
	time_queue[1] = time / 2 - 8


func _on_Timer_timeout():
	match time_ind:
		0:
			music_a.stop()
			music_b.play()
		1:
			music_b.stop()
			music_c.play()
			get_tree().call_group("shadow_hand", "set_difficulty", 1)
		2:
			music_c.stop()
			music_d.play()
			scared_breathing.play()
	if time_ind < 2:
		timer.start(time_queue[time_ind])
	time_ind += 1


func _on_MusicD_finished():
	get_tree().call_group("shadow_hand", "set_difficulty", 2)


func stop_all() -> void:
	music_a.stop()
	music_b.stop()
	music_c.stop()
	music_d.stop()
	scared_breathing.stop()
