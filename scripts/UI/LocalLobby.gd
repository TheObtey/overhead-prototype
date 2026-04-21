extends Control

@export var scGameScene : PackedScene
@onready var uiBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer
@onready var uiStartButton = $MarginContainer/TextureButton

var iCurrentDeviceCount = 0

func _ready() -> void:
	uiBoxContainer.visible = false
	uiStartButton.visible = false

func _input(event) -> void:
	# pour debug iCurrentDeviceCount += 1
	#store le premier divice dans imaginons oPlayer1device
	#if event.device != pPlayer1device:
		#store le deuxieme divice dans imaginons oPlayer2device

	if iCurrentDeviceCount == 2:
		uiStartButton.visible = true
		
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_packed(scGameScene)
	InGameMenu.bCanOpen = true
