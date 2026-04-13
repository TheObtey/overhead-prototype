extends Node

@export var iInteractDistance: float = 2.0
@export var sDefaultPrompt: String = "Interagir"

var oPlayer: CharacterBody3D
var oRayCast: RayCast3D
var oCurrentEntity: Node = null

signal oEntityChanged(oEntity: Node)

func Setup(oNewPlayer: CharacterBody3D) -> void:
	oPlayer = oNewPlayer
	_SetupRayCast()

func ProcessUpdate() -> void:
	_CheckInteraction()
	if Input.is_action_just_pressed("interact"):
		TryInteract()

func TryInteract() -> void:
	if oCurrentEntity and oCurrentEntity.CanInteract(oPlayer):
		oCurrentEntity.Interact(oPlayer)

func GetCurrentPrompt() -> String:
	if oCurrentEntity and oCurrentEntity.has_method("GetPrompt"):
		return oCurrentEntity.GetPrompt()
	return sDefaultPrompt

func _SetupRayCast() -> void:
	oRayCast = RayCast3D.new()
	oRayCast.target_position = Vector3(0, 0, -iInteractDistance)
	oRayCast.collision_mask = 1
	oPlayer.get_node("CameraRoot").add_child(oRayCast)

func _CheckInteraction() -> void:
	if oRayCast.is_colliding():
		var oHit: Node = oRayCast.get_collider()
		var oEntity: Node = _FindEntity(oHit)
		if oEntity and oEntity.CanInteract(oPlayer):
			_SetCurrentEntity(oEntity)
			return
	_SetCurrentEntity(null)

func _FindEntity(oNode: Node) -> Node:
	var oCurrent: Node = oNode
	while oCurrent:
		if oCurrent is EntityBase:
			return oCurrent
		oCurrent = oCurrent.get_parent()
	return null

func _SetCurrentEntity(oEntity: Node) -> void:
	if oEntity == oCurrentEntity:
		return
	oCurrentEntity = oEntity
	oEntityChanged.emit(oCurrentEntity)
