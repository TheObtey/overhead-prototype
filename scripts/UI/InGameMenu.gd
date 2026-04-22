extends Control

@onready var oOptionMenu = $OptionsMenu as OptionsMenu
@onready var oMarginContainer = $MarginContainer as MarginContainer
@export var scMainMenu : PackedScene

var bIsOpen = false
var bCanOpen = false

func _ready() -> void:
	oOptionMenu.sExitMenu.connect(OnExitMenu)
	self.visible = false
	oOptionMenu.visible = false
	oMarginContainer.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func ShowMenu() -> void:
	get_tree().paused = true
	bIsOpen = true
	self.visible = true
	oOptionMenu.visible = false
	oMarginContainer.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func HideMenu() -> void:
	bIsOpen = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _input(event) -> void:
	if bCanOpen == false:
		return

	if event.is_action_pressed("menu"):
		if bIsOpen:
			HideMenu()
			
		else:
			ShowMenu()

func _on_continue_pressed() -> void:
	HideMenu()
	get_tree().paused = false

func _on_options_pressed() -> void:
	oMarginContainer.visible = false
	oOptionMenu.set_process(true)
	oOptionMenu.visible = true

func OnExitMenu() -> void:
	oMarginContainer.visible = true
	oOptionMenu.visible = false

func _on_save_and_quit_pressed() -> void:
	# SaveGame()
	HideMenu()
	get_tree().change_scene_to_packed(scMainMenu)
