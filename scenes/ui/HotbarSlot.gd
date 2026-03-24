extends Panel

@onready var oLabel: Label = $Label

func SetItemName(sNewItemName: String) -> void:
	oLabel.text = sNewItemName

func SetSelected(bSelected: bool) -> void:
	if bSelected:
		modulate = Color(0.328, 1.0, 0.704, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
