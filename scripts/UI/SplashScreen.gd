extends Control

@export var scMainMenu: PackedScene
@export var audioMusic: AudioStream

var bCanSkip := false

func _ready():
	AudioManager.PlayMusic(audioMusic.resource_path)
	
	await get_tree().create_timer(0.5).timeout
	bCanSkip = true

func _input(event):
	if not bCanSkip:
		return

	if (event is InputEventMouseButton or event is InputEventKey) and event.pressed:
		_goToMainMenu()

func _goToMainMenu():
	get_tree().change_scene_to_packed(scMainMenu)
