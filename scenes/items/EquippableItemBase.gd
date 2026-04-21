class_name EquippableItemBase
extends ItemBase

# Base class for items that can be equipped and used.
var pOwner: CharacterBody3D
var bIsEquipped: bool = false

# Called when the item becomes active in equipment.
func OnEquip(pPlayer: CharacterBody3D) -> void:
	bIsEquipped = true
	pOwner = pPlayer
	if self is GravityGun:
		AnimationHandler.bHasGun = true

# Called when the item is no longer active.
func OnUnequip() -> void:
	bIsEquipped = false
	pOwner = null
	if self is GravityGun:
		AnimationHandler.bHasGun = false

# Primary input action (e.g. fire/use).
func OnPrimaryAction() -> void:
	pass

# Secondary input action (e.g. aim/alt fire).
func OnSecondaryAction() -> void:
	pass
