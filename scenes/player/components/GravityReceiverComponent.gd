class_name GravityReceiverComponent
extends Node

@export var vecDefaultGravityDirection: Vector3 = Vector3.DOWN
@export_node_path("Node") var pGravityApplierPath: NodePath

var oOwnerBody: Node
var oGravityApplier: GravityApplierBase
var oActiveGravityField: Area3D
var vecCurrentGravityDirection: Vector3 = Vector3.DOWN

func Setup(oNewOwnerBody: Node3D) -> void:
	oOwnerBody = oNewOwnerBody
	vecCurrentGravityDirection = vecDefaultGravityDirection.normalized()
	
	if pGravityApplierPath.is_empty():
		return
	
	oGravityApplier = get_node_or_null(pGravityApplierPath) as GravityApplierBase
	
	if oGravityApplier == null:
		return
	
	oGravityApplier.Setup(oOwnerBody)
	oGravityApplier.ApplyGravityDirection(vecCurrentGravityDirection)

func ReceiveGravityFromField(oField: Area3D, vecNewGravityDirection: Vector3) -> void:
	oActiveGravityField = oField
	vecCurrentGravityDirection = vecNewGravityDirection.normalized()
	_ApplyGravityDirection()

func ClearGravityFromField(oField: Area3D) -> void:
	if oActiveGravityField != oField:
		return
	
	oActiveGravityField = null
	ResetToDefaultGravity()

func ResetToDefaultGravity() -> void:
	vecCurrentGravityDirection = vecDefaultGravityDirection.normalized()
	_ApplyGravityDirection()

func GetCurrentGravityDirection() -> Vector3:
	return vecCurrentGravityDirection

func HasActiveGravityField() -> bool:
	return oActiveGravityField != null

func _ApplyGravityDirection() -> void:
	if oGravityApplier == null:
		return
	
	oGravityApplier.ApplyGravityDirection(vecCurrentGravityDirection)
