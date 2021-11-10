extends Node

export(float, 60, 120) var game_duration := 60.0

onready var timer := $Timer
onready var music_a := $MusicA
onready var music_b := $MusicB
onready var music_c := $MusicC
onready var music_d := $MusicD

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
		2:
			music_c.stop()
			music_d.play()
	if time_ind < 2:
		timer.start(time_queue[time_ind])
	time_ind += 1
