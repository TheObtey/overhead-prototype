class_name Entity
extends Node3D

@export var sEntityName: String = "Entity"
@export var bCanInteract: bool = true

func CanInteract(pPlayer: CharacterBody3D) -> bool:
	return bCanInteract

func Interact(pPlayer: CharacterBody3D) -> void:
	pass

func GetPrompt() -> String:
	return "Interact with" + sEntityName
