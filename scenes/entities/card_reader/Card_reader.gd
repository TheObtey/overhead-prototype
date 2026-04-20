extends EntityBase

@export var sNeededItem: String

@export var target : Node3D


func GetPrompt() -> String:
	return "Use KeyCard"

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
	
	print("door open")
	if target != null:
		target.Interact(oInteractor)
	
	#queue_free()
	#oInteractor._OnEntityChanged(null)
