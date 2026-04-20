extends Node
@onready var uiMainMenu = $InGameMenu

func _ready() -> void:
	uiMainMenu.visible = false

func _input(event):
	if event.is_action_just_pressed("Menu"):
		uiMainMenu.visible = true
