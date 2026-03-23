extends Area3D

@export var vecGravityDirection: Vector3 = Vector3.DOWN

func _ready() -> void:
	body_entered.connect(_OnBodyEntered)
	body_exited.connect(_OnBodyExited)

func _OnBodyEntered(oBody: Node3D) -> void:
	if not oBody.is_in_group("Player"):
		return
	
	if not oBody.has_method("SetGravityDirection"):
		return
	
	oBody.SetGravityDirection(vecGravityDirection)

func _OnBodyExited(oBody: Node3D) -> void:
	if not oBody.is_in_group("Player"):
		return
	
	if not oBody.has_method("ResetGravityDirection"):
		return
	
	oBody.ResetGravityDirection()
