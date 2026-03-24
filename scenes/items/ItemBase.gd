class_name ItemBase
extends Node

@export var sItemName: String = "Item"
@export var oViewmodelScene: PackedScene

func OnAdded(pPlayer: CharacterBody3D) -> void:
	pass

func OnRemoved(pPlayer: CharacterBody3D) -> void:
	pass

func GetItemName() -> String:
	return sItemName

func GetViewmodelScene() -> PackedScene:
	return oViewmodelScene
