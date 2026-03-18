extends RigidBody3D

@onready var interactable: Area3D = $Interactable
@onready var cube: RigidBody3D = $"."

func _ready() -> void:
	interactable.interact = _on_interact
	
	

func _on_interact():
	interactable.is_interactable = false
	print("cube is carry")
