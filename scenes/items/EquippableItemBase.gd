extends "res://scenes/items/ItemBase.gd"

var pOwner: CharacterBody3D
var bIsEquipped: bool = false

func onEquip(pPlayer: CharacterBody3D) -> void:
	bIsEquipped = true
	pOwner = pPlayer

func OnUnequip() -> void:
	bIsEquipped = false
	pOwner = null

func OnPrimaryAction() -> void:
	pass

func OnSecondaryAction() -> void:
	pass
