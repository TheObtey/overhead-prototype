extends RigidBody3D

@onready var interactable: Area3D = $Interactable
@onready var cylinder: RigidBody3D = $MeshInstance3D
@onready var clean_area: Area3D = $CleanArea

func _ready() -> void:
	interactable.interact = _on_interact
	_clean_nearby_stains()

func _on_interact():
	interactable.is_interactable = false
	print("Broom is carry")

func _clean_nearby_stains() -> void:
	for stain in clean_area.get_overlapping_areas():
		if stain.is_in_group("stains"):
			stain.queue_free()
