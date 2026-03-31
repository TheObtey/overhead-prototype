class_name RigidGravityApplierComponent
extends GravityApplierBase

@export var iGravityStrength: float = 9.8

var oOwnerBody: RigidBody3D
var vecCurrentGravityDirection: Vector3 = Vector3.DOWN

func Setup(oNewOwnerBody: Node) -> void:
	oOwnerBody = oNewOwnerBody as RigidBody3D
	
	if oOwnerBody == null:
		return
	
	oOwnerBody.gravity_scale = 0.0
	vecCurrentGravityDirection = Vector3.DOWN

func ApplyGravityDirection(vecGravityDirection: Vector3) -> void:
	vecCurrentGravityDirection = vecGravityDirection

func _physics_process(iDelta: float) -> void:
	if oOwnerBody == null:
		return
	
	oOwnerBody.apply_central_force(vecCurrentGravityDirection * iGravityStrength * oOwnerBody.mass)
