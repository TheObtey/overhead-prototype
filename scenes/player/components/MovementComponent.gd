extends Node

@export var iMoveSpeed: float = 6.0
@export var iJumpVelocity: float = 5.0
@export var iGravityStrength: float = 20.0
@export var iGravityDetachForce: float = 0.05

var oPlayer: CharacterBody3D
var vecGravityDirection: Vector3 = Vector3.DOWN

func Setup(oNewPlayer: CharacterBody3D) -> void:
	oPlayer = oNewPlayer
	oPlayer.up_direction = -vecGravityDirection

func PhysicsUpdate(iDelta: float) -> void:
	ApplyGravity(iDelta)
	HandleJump()
	HandleMovement()
	
	oPlayer.move_and_slide()

func SetGravityDirection(vecNewGravityDirection: Vector3) -> void:
	vecGravityDirection = vecNewGravityDirection.normalized()
	oPlayer.up_direction = -vecGravityDirection
	
	if oPlayer.is_on_floor():
		oPlayer.velocity += vecGravityDirection * iGravityDetachForce

func ApplyGravity(iDelta: float) -> void:
	if not oPlayer.is_on_floor():
		oPlayer.velocity += vecGravityDirection * iGravityStrength * iDelta

func HandleJump() -> void:
	if Input.is_action_just_pressed("jump") and oPlayer.is_on_floor():
		oPlayer.velocity -= vecGravityDirection * iJumpVelocity

func HandleMovement() -> void:
	var vecInputDir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var vecForward: Vector3 = oPlayer.global_transform.basis.z
	var vecRight: Vector3 = oPlayer.global_transform.basis.x
	
	vecForward.y = 0.0
	vecRight.y = 0.0
	
	vecForward = vecForward.normalized()
	vecRight = vecRight.normalized()
	
	var vecMoveDir: Vector3 = (vecRight * vecInputDir.x + vecForward * vecInputDir.y).normalized()
	
	if vecMoveDir != Vector3.ZERO:
		oPlayer.velocity.x = vecMoveDir.x * iMoveSpeed
		oPlayer.velocity.z = vecMoveDir.z * iMoveSpeed
	else:
		oPlayer.velocity.x = move_toward(oPlayer.velocity.x, 0.0, iMoveSpeed)
		oPlayer.velocity.z = move_toward(oPlayer.velocity.z, 0.0, iMoveSpeed)
