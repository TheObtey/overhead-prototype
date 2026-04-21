extends EntityBase

@export var sNeededItem: String
@export var oTarget : Node3D

var oCollectible : Node

func GetPrompt() -> String:
	return "Use KeyCard"

func CanInteract(oInteractor: Node) -> bool:
	if bCanInteract == false:
		return false
	
	if not oInteractor:
		return false
	
	var oInventoryComponent = oInteractor.GetInventoryComponent()
	
	if not oInventoryComponent:
		return false
	
	oCollectible = oInventoryComponent.GetCollectibleByName(sNeededItem)
	
	print(oCollectible)
	
	if oCollectible is ItemBase:
		return true
	
	return false

func Interact(oInteractor: Node) -> void:
	if not CanInteract(oInteractor):
		return
	
	var oInventoryComponent = oInteractor.GetInventoryComponent()
	oInventoryComponent.UseCollectible(oCollectible)
	
	if oTarget != null:
		oTarget.Interact(oInteractor)
	
