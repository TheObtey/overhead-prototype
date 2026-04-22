extends Node

var pAudioPlayer: AudioStreamPlayer2D
var oCurrentPath := ""

func _ready():
	pAudioPlayer = AudioStreamPlayer2D.new()
	add_child(pAudioPlayer)

func PlayMusic(sPath: String):
	if oCurrentPath == sPath:
		return

	oCurrentPath = sPath
	var oMusic = load(sPath)
	pAudioPlayer.stream = oMusic
	pAudioPlayer.bus = "Music"
	pAudioPlayer.play()

func StopMusic():
	pAudioPlayer.stop()
