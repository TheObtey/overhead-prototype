extends Control

@onready var oOptionButton = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONNARY : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
 	"1920 x 1080" : Vector2i(1920, 1080),
	"2560  x 1440 " : Vector2i(2560 , 1440),
	"3840 x 2160" : Vector2i(3840, 2160),
}

func _ready():
	oOptionButton.item_selected.connect(on_resolution_selected)
	add_resolution_items()

func add_resolution_items() -> void:
	for resolution_size_text in RESOLUTION_DICTIONNARY:
		oOptionButton.add_item(resolution_size_text)

func on_resolution_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_DICTIONNARY.values()[index])
