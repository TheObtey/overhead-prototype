extends Control

@onready var oOptionMenu = $OptionsMenu as OptionsMenu
@onready var oMarginContainer = $MarginContainer as MarginContainer

func _ready() -> void:
	oOptionMenu.sExitMenu.connect(OnExitMenu)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/ElouanGamingRoom.tscn")

func _on_options_pressed() -> void:
	oMarginContainer.visible = false
	oOptionMenu.set_process(true)
	oOptionMenu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	pass # Replace with function body.

func OnExitMenu() -> void:
	oMarginContainer.visible = true
	oOptionMenu.visible = false
