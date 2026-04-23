extends EntityBase

@onready var oMesh: Node3D = $RigidBody3D/SpringAnim
@onready var oAnimPlayer: AnimationPlayer = $RigidBody3D/SpringAnim/AnimationPlayer
@onready var oArea: Area3D = $Area3D

@export var iJumpForce: float = 15.0

func _ready():
	oArea.body_entered.connect(_on_body_entered)

func _on_body_entered(oBody: Node):
	if not oBody is PlayerBase:
		return
	
	_OnPlayerHop(oBody)

func _OnPlayerHop(oPlayer: PlayerBase):
	oAnimPlayer.play("Spring Anim")
	
	var vecUp = oMesh.global_transform.basis.y.normalized()
	oPlayer.velocity += vecUp * iJumpForce
