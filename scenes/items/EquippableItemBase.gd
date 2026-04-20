class_name EquippableItemBase
extends ItemBase

var pOwner: CharacterBody3D
var bIsEquipped: bool = false

func OnEquip(pPlayer: CharacterBody3D) -> void:
	bIsEquipped = true
	pOwner = pPlayer
	if self is GravityGun:
		AnimationHandler.bHasGun = true

func OnUnequip() -> void:
	bIsEquipped = false
	pOwner = null
	if self is GravityGun:
		AnimationHandler.bHasGun = false

func OnPrimaryAction() -> void:
	pass

func OnSecondaryAction() -> void:
	pass
