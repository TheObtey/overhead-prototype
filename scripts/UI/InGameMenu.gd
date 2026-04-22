extends Control

@onready var uiOptionMenu = $OptionsMenu as OptionsMenu
@onready var uiMarginContainer = $MarginContainer as MarginContainer
@onready var uiBg = $ColorRect as ColorRect
@export var scMainMenu : PackedScene

var bIsOpen = false
var bCanOpen = false

func _ready() -> void:
	uiOptionMenu.sExitMenu.connect(OnExitMenu)
	self.visible = false
	uiOptionMenu.visible = false
	uiMarginContainer.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func ShowMenu() -> void:
	get_tree().paused = true
	bIsOpen = true
	self.visible = true
	uiOptionMenu.visible = false
	uiMarginContainer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func HideMenu() -> void:
	bIsOpen = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _input(event) -> void:
	if bCanOpen == false:
		return

	if event.is_action_pressed("Menu"):
		if bIsOpen:
			HideMenu()
			
		else:
			ShowMenu()

func _on_continue_pressed() -> void:
	HideMenu()
	get_tree().paused = false

func _on_options_pressed() -> void:
	uiMarginContainer.visible = false
	uiOptionMenu.set_process(true)
	uiOptionMenu.visible = true
	uiBg.visible = false

func OnExitMenu() -> void:
	uiMarginContainer.visible = true
	uiOptionMenu.visible = false
	uiBg.visible = true

func _on_save_and_quit_pressed() -> void:
	# SaveGame()
	HideMenu()
	get_tree().change_scene_to_packed(scMainMenu)
