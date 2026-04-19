extends EntityBase

@export var sNeededItem: String

func GetPrompt() -> String:
	return "Clean"

func CanInteract(oInteractor: Node) -> bool:
	if bCanInteract == false:
		return false
	
	if not oInteractor:
		return false
	
	var oEquipmentComponent = oInteractor.GetEquipmentComponent()
	
	if not oEquipmentComponent:
		return false
	
	var oEquippedItem = oEquipmentComponent.GetCurrentItem()
	
	if not oEquippedItem or oEquippedItem.GetItemName() != sNeededItem:
		return false
	
	return true

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	print("stain cleaned")
	
	queue_free()
	oInteractor._OnEntityChanged(null)
