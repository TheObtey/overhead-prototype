extends Control

@export var scMainMenu: PackedScene

var can_skip := false

func _ready():
	AudioManager.PlayMusic("res://Audio/Musics/Tests overhead.mp3")
	
	await get_tree().create_timer(0.5).timeout
	can_skip = true
	
func _input(event):
	if not can_skip:
		return

	if event is InputEventKey and event.pressed:
		_GoToMainMenu()
	elif event is InputEventMouseButton and event.pressed:
		_GoToMainMenu()
	elif event is InputEventJoypadButton and event.pressed:
		_GoToMainMenu()

func _GoToMainMenu():
	get_tree().change_scene_to_packed(scMainMenu)
