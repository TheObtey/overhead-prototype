extends CanvasLayer

@onready var uiOptionMenu = $OptionsMenu as OptionsMenu
@onready var uiMarginContainer = $MarginContainer as MarginContainer
@onready var uiBg = $ColorRect as ColorRect
@export var scMainMenu : PackedScene

var bIsOpen = false
var bCanOpen = false

func _ready() -> void:
	self.layer = 10
	uiOptionMenu.sExitMenu.connect(OnExitMenu)
	self.hide()
	uiOptionMenu.hide()
	uiMarginContainer.hide()
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func ShowMenu() -> void:
	get_tree().paused = true
	bIsOpen = true
	self.show()
	uiBg.show()
	uiOptionMenu.hide()
	uiMarginContainer.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func HideMenu() -> void:
	bIsOpen = false
	self.hide()
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

func _on_options_pressed() -> void:
	uiMarginContainer.hide()
	uiOptionMenu.set_process(true)
	uiOptionMenu.show()
	uiBg.hide()

func OnExitMenu() -> void:
	uiMarginContainer.show()
	uiOptionMenu.hide()
	uiBg.show()

func _on_save_and_quit_pressed() -> void:
	HideMenu()
	get_tree().change_scene_to_packed(scMainMenu)
