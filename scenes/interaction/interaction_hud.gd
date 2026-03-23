# interaction_hud.gd
extends CanvasLayer

@onready var label := $Label

func set_prompt(text: String) -> void:
	label.text = "[E] " + text

func _ready() -> void:
	visible = false
