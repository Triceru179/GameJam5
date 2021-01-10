extends Node

func _ready():
	MusicPlayer.change_playlist([load("res://songs/Komiku_-_Poupis_incredible_adventures__-_07_Run_against_the_universe_1.ogg"),
		load("res://songs/Komiku_-_Poupis_incredible_adventures__-_30_Escaping_the_Collapsing_Universe_0.ogg")])
