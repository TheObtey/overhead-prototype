extends Control

@export var scMainMenu: PackedScene

var bCanSkip := false

func _ready():
	AudioManager.PlayMusic("res://Audio/Musics/Tests overhead.mp3")
	
	await get_tree().create_timer(0.5).timeout
	bCanSkip = true

func _input(event):
	if not bCanSkip:
		return

	if event.pressed:
		_goToMainMenu()

func _goToMainMenu():
	get_tree().change_scene_to_packed(scMainMenu)
