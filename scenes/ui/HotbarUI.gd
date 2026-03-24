extends CanvasLayer

@export var oHotbarSlotScene: PackedScene

@onready var oHBoxContainer: HBoxContainer = $MarginContainer/HBoxContainer

var pPlayer: CharacterBody3D
var oInventoryComponent: Node
var oEquipmentComponent: Node

func Setup(pNewPlayer: CharacterBody3D, oNewInventoryComponent: Node, oNewEquipmentComponent: Node) -> void:
	pPlayer = pNewPlayer
	oInventoryComponent = oNewInventoryComponent
	oEquipmentComponent = oNewEquipmentComponent
	
	if not oInventoryComponent.InventoryChanged.is_connected(_OnInventoryChanged):
		oInventoryComponent.InventoryChanged.connect(_OnInventoryChanged)
	
	if not oEquipmentComponent.EquippedItemChanged.is_connected(_OnEquippedItemChanged):
		oEquipmentComponent.EquippedItemChanged.connect(_OnEquippedItemChanged)
	
	Refresh()

func _OnInventoryChanged() -> void:
	Refresh()

func _OnEquippedItemChanged() -> void:
	Refresh()

func Refresh() -> void:
	if not oHotbarSlotScene:
		return
	
	for oChild in oHBoxContainer.get_children():
		oChild.queue_free()
	
	var tItems: Array = oInventoryComponent.GetItems()
	var oCurrentItem: Node = oEquipmentComponent.GetCurrentItem()
	
	for oItem in tItems:
		var oSlot = oHotbarSlotScene.instantiate()
		oHBoxContainer.add_child(oSlot)
		
		oSlot.SetItemName(oItem.sItemName)
		oSlot.SetSelected(oItem == oCurrentItem)
