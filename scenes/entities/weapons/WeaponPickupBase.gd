class_name WeaponPickupBase
extends EntityBase

@export var oWeaponScene: PackedScene
@export var bAutoEquipOnPickup = false

func GetPrompt() -> String:
	return "Pickup"

func Interact(pPlayer: CharacterBody3D) -> void:
	if not pPlayer or not oWeaponScene:
		return
	
	var oItem = oWeaponScene.instantiate()
	
	if not oItem:
		return
	
	var oInventoryComponent = pPlayer.GetInventoryComponent()
	var oEquipmentComponent = pPlayer.GetEquipmentComponent()
	
	if oInventoryComponent:
		oInventoryComponent.AddItem(oItem)
	
	if oEquipmentComponent and bAutoEquipOnPickup:
		oEquipmentComponent.EquipItem(oItem)
	
	queue_free()
	pPlayer._OnEntityChanged(null)
