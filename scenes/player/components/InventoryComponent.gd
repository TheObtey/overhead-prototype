extends Node

# Inventory container owned by a player.
# Stores item instances and emits a change signal for UI/systems.
signal InventoryChanged

var pPlayer: CharacterBody3D
var tItems: Array = []

# Binds this inventory to its player owner.
func Setup(pNewPlayer: CharacterBody3D) -> void:
	pPlayer = pNewPlayer

# Adds an item and triggers the item's add lifecycle hook.
func AddItem(oItem: Node) -> void:
	if not oItem:
		return
	
	tItems.append(oItem)
	oItem.OnAdded(pPlayer)
	
	InventoryChanged.emit()

# Removes an item and triggers the item's remove lifecycle hook.
func RemoveItem(oItem: Node) -> void:
	if not tItems.has(oItem):
		return
	
	tItems.erase(oItem)
	oItem.OnRemove(pPlayer)
	
	InventoryChanged.emit()

# Returns the current inventory list.
func GetItems() -> Array:
	return tItems
