extends Node

signal EquippedItemChanged

var pPlayer: CharacterBody3D
var oCurrentItem: ItemBase

func Setup(pNewPlayer: CharacterBody3D) -> void:
	pPlayer = pNewPlayer

func EquipItem(oItem: Node) -> void:
	if not oItem:
		return
	
	if oCurrentItem:
		oCurrentItem.OnUnequip()
	
	oCurrentItem = oItem
	oCurrentItem.OnEquip(pPlayer)
	
	EquippedItemChanged.emit()

func UnequipCurrentItem() -> void:
	if not oCurrentItem:
		return
	
	oCurrentItem.OnUnequip()
	oCurrentItem = null
	
	EquippedItemChanged.emit()

func GetCurrentItem() -> Node:
	return oCurrentItem

func HandleInput() -> void:
	if not oCurrentItem:
		return
	
	if Input.is_action_just_pressed("primary_attack"):
		oCurrentItem.OnPrimaryAction()
	
	if Input.is_action_just_pressed("secondary_attack"):
		oCurrentItem.OnSecondaryAction()
