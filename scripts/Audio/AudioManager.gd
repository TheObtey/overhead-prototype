extends Node

var pPlayer: AudioStreamPlayer2D
var oCurrentPath := ""

func _ready():
	pPlayer = AudioStreamPlayer2D.new()
	add_child(pPlayer)

func PlayMusic(path: String):
	if oCurrentPath == path:
		return

	oCurrentPath = path
	var music = load(path)
	pPlayer.stream = music
	pPlayer.play()

func StopMusic():
	pPlayer.stop()

#TO_DO
#SwitchMusic(newPath: String)
