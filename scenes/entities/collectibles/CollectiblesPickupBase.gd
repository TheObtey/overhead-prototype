class_name CollectiblesPickupBase
extends EntityBase

# Pickup entity that grants a Collectible item to the interactor.
@export var oCollectibleScene: PackedScene
@export var bAutoEquipOnPickup = false

# Short pickup-specific interaction prompt.
func GetPrompt() -> String:
	return "Pickup"

# Instantiates the configured collectible item, adds it to inventory,
func Interact(oInteractor: Node) -> void:
	if not oInteractor or not oCollectibleScene:
		return
	var oItem = oCollectibleScene.instantiate()
	if not oItem:
		return
	var oInventoryComponent = oInteractor.GetInventoryComponent()
	if oInventoryComponent:
		#oInventoryComponent.AddItem(oItem)
		oInventoryComponent.AddCollectible(oItem)
	
	queue_free()
	oInteractor._OnEntityChanged(null)
