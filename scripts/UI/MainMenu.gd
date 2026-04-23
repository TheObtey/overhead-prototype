extends Control

@onready var oOptionMenu = $OptionsMenu as OptionsMenu
@onready var oMarginContainer = $MarginContainer as MarginContainer
@export var scLobby : PackedScene
 
func _ready() -> void:
	oOptionMenu.sExitMenu.connect(OnExitMenu)
	InGameMenu.bCanOpen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(scLobby)
	InGameMenu.bCanOpen = true

func _on_options_pressed() -> void:
	oMarginContainer.visible = false
	oOptionMenu.set_process(true)
	oOptionMenu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func OnExitMenu() -> void:
	oMarginContainer.visible = true
	oOptionMenu.visible = false
