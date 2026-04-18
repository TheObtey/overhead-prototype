extends Node

var pPlayer: AudioStreamPlayer2D
var oCurrentPath := ""

func _ready():
	pPlayer = AudioStreamPlayer2D.new()
	add_child(pPlayer)

func PlayMusic(sPath: String):
	if oCurrentPath == sPath:
		return

	oCurrentPath = sPath
	var oMusic = load(sPath)
	pPlayer.stream = oMusic
	pPlayer.play()

func StopMusic():
	pPlayer.stop()
