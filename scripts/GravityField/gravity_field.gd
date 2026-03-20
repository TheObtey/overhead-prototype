extends Area3D

@export var field_gravity_strength: float = 30.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.has_method("set_gravity_field"):
		var field_forward: Vector3 = global_transform.basis.y.normalized()
		body.set_gravity_field(field_forward, field_gravity_strength)

func _on_body_exited(body: Node) -> void:
	if body.has_method("clear_gravity_field"):
		body.clear_gravity_field(self)
