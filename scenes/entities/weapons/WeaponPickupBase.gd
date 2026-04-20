class_name WeaponPickupBase
extends EntityBase

# Pickup entity that grants a weapon item to the interactor.
@export var oWeaponScene: PackedScene
@export var bAutoEquipOnPickup = false

# Short pickup-specific interaction prompt.
func GetPrompt() -> String:
	return "Pickup"

# Instantiates the configured weapon item, adds it to inventory,
# optionally equips it, then removes the pickup from the world.
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
