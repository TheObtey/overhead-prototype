extends Control

@onready var oOptionMenu = $OptionsMenu as OptionsMenu
@onready var oMarginContainer = $MarginContainer as MarginContainer

var bIsOpen = false 

func _ready() -> void:
	self.visible = false
	oOptionMenu.sExitMenu.connect(OnExitMenu)

func SwitchMenuVisibility() -> void:
	bIsOpen = !bIsOpen
	self.visible = !bIsOpen
	oOptionMenu.visible = bIsOpen
	oMarginContainer.visible = !bIsOpen

func _input(event) -> void:
	if event.is_action_pressed("Menu"):
		SwitchMenuVisibility()

func _on_continue_pressed() -> void:
	pass

func _on_options_pressed() -> void:
	oMarginContainer.visible = false
	oOptionMenu.set_process(true)
	oOptionMenu.visible = true

func OnExitMenu() -> void:
	oMarginContainer.visible = true
	oOptionMenu.visible = false

func _on_save_and_quit_pressed() -> void:
	get_tree().quit()
