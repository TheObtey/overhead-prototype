extends RigidBody3D

@export var iWalkSpeed := 1200

# Called every frame. 'iDelta' is the elapsed time since the previous frame.
func _physics_process(iDelta: float) -> void:
	if multiplayer == null or not multiplayer.has_multiplayer_peer():
		return
	
	if not is_multiplayer_authority():
		return
	
	var vecInput := Vector3.ZERO
	vecInput.x = Input.get_axis("move_left", "move_right")
	vecInput.z = Input.get_axis("move_forward", "move_backward")
	vecInput = vecInput.normalized()
	
	apply_central_force(vecInput * iWalkSpeed * iDelta)
	get_node("/root/Node3D/NetworkManager").send_player_transform(global_position, global_rotation)
