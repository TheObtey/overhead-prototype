extends Node3D

@export var sEntityName: String = "Entity"
@export var bCanInteract: bool = true

func CanInteract(pPlayer: CharacterBody3D) -> void:
	pass

func Interact(pPlayer: CharacterBody3D) -> void:
	pass
