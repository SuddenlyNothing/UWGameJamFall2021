extends Node

onready var songs := {
	"title" : $TitleMusic
}


func play(song : String) -> void:
	if not song in songs:
		return
	if songs[song].is_playing():
		return
	stop_all()
	songs[song].call_deferred("play")


func stop_all() -> void:
	for song in songs:
		songs[song].stop()
