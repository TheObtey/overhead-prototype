class_name OptionsMenu
extends Control

signal sExitMenu

func _on_texture_button_pressed() -> void:
	sExitMenu.emit()
	set_process(false)
