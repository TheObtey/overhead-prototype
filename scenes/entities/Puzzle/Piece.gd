extends Node

@export var fPosX: float = 0.0
@export var fPosY: float = 0.0
@export var fPosZ: float = 0.0
@export var fRotX: float = 0.0
@export var fRotY: float = 0.0
@export var fRotZ: float = 0.0
var oChild: Node

@export var oTarget: Node3D

var bPlaced: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	oChild = get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	OnrangeOfFrame()
	
func OnrangeOfFrame() -> void:

	if oChild and (oChild is RigidBody3D) and bPlaced == false:
		var ChildPosition = oChild.global_position
		
		if (ChildPosition.x < -9 and ChildPosition.x > -10 and
			ChildPosition.y < 23 and ChildPosition.y > 21 and
			ChildPosition.z < 0 and ChildPosition.z > -2):
				
				oChild.set_collision_layer(2)
				oChild.set_collision_mask(2)
				oChild.freeze = true
				oChild.global_position = Vector3(fPosX, fPosY, fPosZ)
				#Child.rotate_object_local(Vector3(1, 1, 0), 0.1)
				#Child.set_deferred("freeze", true)
				oChild.bIsCarriable = false
				bPlaced = true
				if oTarget != null:
					oTarget.Interactkey()
	else :
		return
