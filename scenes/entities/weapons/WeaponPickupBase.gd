class_name WeaponPickupBase
extends EntityBase

@export var oWeaponScene: PackedScene
@export var bAutoEquipOnPickup = false

func GetPrompt() -> String:
	return "Pickup"

func Interact(oInteractor: Node) -> void:
	if not oInteractor or not oWeaponScene:
		return
	
	var oItem = oWeaponScene.instantiate()
	
	if not oItem:
		return
	
	var oInventoryComponent = oInteractor.GetInventoryComponent()
	var oEquipmentComponent = oInteractor.GetEquipmentComponent()
	
	if oInventoryComponent:
		oInventoryComponent.AddItem(oItem)
	
	if oEquipmentComponent and bAutoEquipOnPickup:
		oEquipmentComponent.EquipItem(oItem)
	
	queue_free()
	oInteractor._OnEntityChanged(null)
