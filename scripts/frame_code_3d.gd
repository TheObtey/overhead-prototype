extends Node3D

@onready var interactable: Area3D = $Interactable
const FRAME_CODE = preload("res://scenes/FrameCode.tscn")

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	interactable.is_interactable = false
	print("I load 2D code frame")
	var instance = FRAME_CODE.instantiate()
	get_tree().root.add_child(instance)
