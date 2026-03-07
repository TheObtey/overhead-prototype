extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'iDelta' is the elapsed time since the previous frame.
func _process(iDelta: float) -> void:
	var vecInput := Vector3.ZERO
	vecInput.x = Input.get_axis("move_left", "move_right")
	vecInput.z = Input.get_axis("move_forward", "move_backward")
	
	apply_central_force(vecInput * 1200 * iDelta)
