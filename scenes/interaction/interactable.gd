class_name Interactable
extends Node

func interact(interactor: Node) -> void:
	pass  # Comportement à surcharger

func get_prompt() -> String:
	return "Interagir"  # Texte à surcharger
