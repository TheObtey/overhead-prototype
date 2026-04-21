class_name ItemBase
extends Node

# Base inventory item.
# Provides metadata and lifecycle hooks for when an item
# is added to or removed from a player's inventory.
@export var sItemName: String = "Item"
@export var oViewmodelScene: PackedScene

# Called right after this item is added to inventory.
func OnAdded(pPlayer: CharacterBody3D) -> void:
	pass

# Called right after this item is removed from inventory.
func OnRemoved(pPlayer: CharacterBody3D) -> void:
	pass

# Display name used in UI and debugging.
func GetItemName() -> String:
	return sItemName

# Optional first-person viewmodel scene for this item.
func GetViewmodelScene() -> PackedScene:
	return oViewmodelScene
