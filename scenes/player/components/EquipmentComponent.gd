extends Node

signal EquippedItemChanged

var pPlayer: CharacterBody3D
var oCurrentItem: ItemBase
var oViewmodelRoot: Node3D
var oCurrentViewmodel: Node3D

func Setup(pNewPlayer: CharacterBody3D, oNewViewmodelRoot: Node3D) -> void:
	pPlayer = pNewPlayer
	oViewmodelRoot = oNewViewmodelRoot

func CreateViewmodel(oItem: Node) -> void:
	if not oItem is ItemBase:
		return
	
	var oScene: PackedScene = oItem.GetViewmodelScene()
	
	if not oScene:
		return
	
	var oInstance = oScene.instantiate()
	
	if not oInstance is Node3D:
		return
	
	oViewmodelRoot.add_child(oInstance)
	oCurrentViewmodel = oInstance

func ClearViewmodel() -> void:
	if not oCurrentViewmodel:
		return
	
	oCurrentViewmodel.queue_free()
	oCurrentViewmodel = null

func EquipItem(oItem: Node) -> void:
	if not oItem:
		return
	
	if oCurrentItem:
		oCurrentItem.OnUnequip()
	
	ClearViewmodel()
	
	oCurrentItem = oItem
	oCurrentItem.OnEquip(pPlayer)
	
	CreateViewmodel(oCurrentItem)
	
	EquippedItemChanged.emit()

func UnequipCurrentItem() -> void:
	if not oCurrentItem:
		return
	
	oCurrentItem.OnUnequip()
	oCurrentItem = null
	
	ClearViewmodel()
	
	EquippedItemChanged.emit()

func EquipItemByIndex(iIndex: int, tItems: Array) -> void:
	if iIndex < 0 or iIndex >= tItems.size():
		return
	
	var oItem = tItems[iIndex]
	
	if oItem != oCurrentItem:
		EquipItem(oItem)

func GetCurrentItem() -> Node:
	return oCurrentItem

func HandleInput() -> void:
	if not oCurrentItem:
		return
	
	if Input.is_action_just_pressed("primary_attack"):
		oCurrentItem.OnPrimaryAction()
	
	if Input.is_action_just_pressed("secondary_attack"):
		oCurrentItem.OnSecondaryAction()
