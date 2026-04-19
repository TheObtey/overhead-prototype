class_name EntityComponent
extends Node

func CanInteract(oInteractor: Node) -> bool:
	return true

func OnInteract(oInteractor: Node) -> void:
	pass

func GetPromptOverride() -> String:
	return ""
