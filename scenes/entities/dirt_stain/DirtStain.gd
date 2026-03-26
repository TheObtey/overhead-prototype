extends EntityBase

@export var sNeededItem: String

func GetPrompt() -> String:
	return "Clean"

func CanInteract(pPlayer: CharacterBody3D) -> bool:
	if bCanInteract == false:
		return false
	
	if not pPlayer:
		return false
	
	var oEquipmentComponent = pPlayer.GetEquipmentComponent()
	
	if not oEquipmentComponent:
		return false
	
	var oEquippedItem = oEquipmentComponent.GetCurrentItem()
	
	if not oEquippedItem or oEquippedItem.GetItemName() != sNeededItem:
		return false
	
	return true

func Interact(pPlayer: CharacterBody3D) -> void:
	if not CanInteract(pPlayer):
		return
	
	print("stain cleaned")
	
	queue_free()
	pPlayer._OnEntityChanged(null)
