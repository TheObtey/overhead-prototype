class_name GravityApplierBase
extends Node

# Abstract interface for components that can apply
# directional gravity to a body.
func Setup(oOwnerBody: Node) -> void:
	pass

# Called by gravity systems when gravity direction changes.
func ApplyGravityDirection(vecGravityDirection: Vector3) -> void:
	pass
