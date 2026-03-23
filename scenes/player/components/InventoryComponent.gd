extends Node

var pPlayer: CharacterBody3D
var tItems: Array = []

func Setup(pNewPlayer: CharacterBody3D) -> void:
	pPlayer = pNewPlayer

func AddItem(oItem: Node) -> void:
	if not oItem:
		return
	
	tItems.append(oItem)
	oItem.OnAdded(pPlayer)

func RemoveItem(oItem: Node) -> void:
	if not tItems.has(oItem):
		return
	
	tItems.erase(oItem)
	oItem.OnRemove(pPlayer)

func GetItems() -> Array:
	return tItems
