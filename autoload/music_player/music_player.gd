extends Node

var pl := []
var last_song_index := -1

func change_song():
	var song
	if last_song_index == -1:
		var i = randi() % pl.size()
		song = pl[i]
		
		last_song_index = i
		
	else:
		var temp_pl = pl
		temp_pl.remove(last_song_index)
		
		var i = randi() % temp_pl.size()
		song = temp_pl[i]
		
		last_song_index = pl.find(temp_pl[i])
	
	var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
	if song != audio_stream_player.stream:
		audio_stream_player.stream = song
		audio_stream_player.play()

func change_playlist(playlist: Array):
	last_song_index = -1
	pl = playlist
	
	if pl.size() <= 0:
		push_error("Playlist can't contain less than one song.")
	
	change_song()
