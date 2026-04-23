extends Node

@export var PosX: float = 0.0
@export var PosY: float = 0.0
@export var PosZ: float = 0.0
@export var RotX: float = 0.0
@export var RotY: float = 0.0
@export var RotZ: float = 0.0
var Child: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Child = get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	OnrangeOfFrame()
	
func OnrangeOfFrame() -> void:
	"if Child.bIsCarriable:
		return
	"
	if Child and (Child is RigidBody3D):
		var ChildPosition = Child.global_position
		if (ChildPosition.x < 8 and ChildPosition.x > 6 and
			ChildPosition.y < 4 and ChildPosition.y > 1.5 and
			ChildPosition.z < -8.5 and ChildPosition.z > -9.5):
				Child.set_collision_layer(2)
				Child.set_collision_mask(2)
				Child.freeze = true
				Child.global_position = Vector3(PosX, PosY, PosZ)
				#Child.rotate_object_local(Vector3(1, 1, 0), 0.1)
				#Child.set_deferred("freeze", true)
				Child.bIsCarriable = false
	else :
		return
