class_name CharacterGravityApplierComponent
extends GravityApplierBase

@export_node_path("Node") var pMovementComponentPath: NodePath

var oOwnerBody: CharacterBody3D
var oMovementComponent: Node

func Setup(oNewOwnerBody: Node) -> void:
	oOwnerBody = oNewOwnerBody as CharacterBody3D
	
	if oOwnerBody == null:
		return
	
	if pMovementComponentPath.is_empty():
		return
	
	oMovementComponent = get_node_or_null(pMovementComponentPath)
	
	if oMovementComponent == null:
		return

func ApplyGravityDirection(vecGravityDirection: Vector3) -> void:
	if oMovementComponent == null:
		return
	
	if not oMovementComponent.has_method("SetGravityDirection"):
		return
	
	oMovementComponent.SetGravityDirection(vecGravityDirection.normalized())
