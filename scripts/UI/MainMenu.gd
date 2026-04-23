extends Control

@onready var uiOptionMenu = $OptionsMenu as OptionsMenu
@onready var uiMarginContainer = $MarginContainer as MarginContainer
@onready var uiLogo = $TextureRect2 as TextureRect
@export var scLobby : PackedScene
 
func _ready() -> void:
	uiOptionMenu.sExitMenu.connect(OnExitMenu)
	InGameMenu.bCanOpen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(scLobby)

func _on_options_pressed() -> void:
	uiMarginContainer.visible = false
	uiLogo.visible = false
	uiOptionMenu.set_process(true)
	uiOptionMenu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func OnExitMenu() -> void:
	uiMarginContainer.visible = true
	uiLogo.visible = true
	uiOptionMenu.visible = false
