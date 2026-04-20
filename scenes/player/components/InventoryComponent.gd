extends Node

# Inventory container owned by a player.
# Stores item instances and emits a change signal for UI/systems.
signal InventoryChanged

var oPlayer: Node
var tItems: Array = []
var tCollectibles: Array = []

# Binds this inventory to its player owner.
func Setup(oNewPlayer: Node) -> void:
	oPlayer = oNewPlayer

# Adds an item and triggers the item's add lifecycle hook.
func AddItem(oItem: Node) -> void:
	if not oItem:
		return
	
	tItems.append(oItem)
	oItem.OnAdded(oPlayer)
	
	InventoryChanged.emit()

# Removes an item and triggers the item's remove lifecycle hook.
func RemoveItem(oItem: Node) -> void:
	if not oItem or not tItems.has(oItem):
		return
	
	tItems.erase(oItem)
	oItem.OnRemove(oPlayer)
	
	InventoryChanged.emit()

# Returns the current items list.
func GetItems() -> Array:
	return tItems

# Adds a collectible and triggers the item's add lifecycle hook.
func AddCollectible(oCollectible: Node) -> void:
	if not oCollectible:
		return
	
	tCollectibles.append(oCollectible)
	oCollectible.OnAdded(oPlayer)
	
	InventoryChanged.emit()

# Removes a collectible and triggers the item's remove lifecycle hook.
func RemoveCollectible(oCollectible: Node) -> void:
	if not oCollectible or not tCollectibles.has(oCollectible):
		return
	
	tCollectibles.erase(oCollectible)
	oCollectible.OnRemove(oPlayer)
	
	InventoryChanged.emit()

# Returns the current collectibles list.
func GetCollectibles() -> Array:
	return tCollectibles

# Removes and return true if player has collectible, false otherwise
func UseCollectible(oCollectible: Node) -> bool:
	if not oCollectible or not tCollectibles.has(oCollectible):
		return false
	
	RemoveCollectible(oCollectible)
	
	return true
