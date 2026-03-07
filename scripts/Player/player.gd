extends RigidBody3D

# Called every frame. 'iDelta' is the elapsed time since the previous frame.
func _process(iDelta: float) -> void:
	if multiplayer == null or not multiplayer.has_multiplayer_peer():
		return
	
	if not is_multiplayer_authority():
		return
	
	var vecInput := Vector3.ZERO
	vecInput.x = Input.get_axis("move_left", "move_right")
	vecInput.z = Input.get_axis("move_forward", "move_backward")
	
	apply_central_force(vecInput * 1200 * iDelta)
	get_node("/root/Node3D/NetworkManager").send_player_transform(global_position, global_rotation)
