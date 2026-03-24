class_name EquippableItemBase
extends ItemBase

var pOwner: CharacterBody3D
var bIsEquipped: bool = false

func OnEquip(pPlayer: CharacterBody3D) -> void:
	bIsEquipped = true
	pOwner = pPlayer
	print(pOwner.name + " equipped " + name)

func OnUnequip() -> void:
	bIsEquipped = false
	pOwner = null

func OnPrimaryAction() -> void:
	pass

func OnSecondaryAction() -> void:
	pass
