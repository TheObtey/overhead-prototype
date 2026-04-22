extends Node

@export var iMoveSpeed: float = 6.0
@export var iJumpVelocity: float = 5.0
@export var iGravityStrength: float = 20.0
@export var iGravityDetachForce: float = 0.05
@export var iRotationSpeed: float = 4.0

var oPlayer: CharacterBody3D
var vecGravityDirection: Vector3 = Vector3.DOWN

func Setup(oNewPlayer: CharacterBody3D) -> void:
	oPlayer = oNewPlayer
	oPlayer.up_direction = -vecGravityDirection

func PhysicsUpdate(iDelta: float) -> void:
	UpdateOrientation(iDelta)
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
		AnimationHandler.enumNewStatePlayer[oPlayer.iPlayerID] = AnimationHandler.AnimState.JUMP

func HandleMovement() -> void:
	var vecInputDir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var vecUp: Vector3 = -vecGravityDirection
	var vecForward: Vector3 = oPlayer.global_transform.basis.z
	
	vecForward = vecForward.slide(vecGravityDirection).normalized()
	
	if vecForward.length() < 0.001:
		vecForward = Vector3.FORWARD.slide(vecGravityDirection).normalized()
	
	var vecRight: Vector3 = -vecForward.cross(vecUp).normalized()
	var vecMoveDir: Vector3 = (
		vecRight * vecInputDir.x +
		vecForward * vecInputDir.y
	).normalized()
	
	var vecGravityVelocity: Vector3 = vecGravityDirection * oPlayer.velocity.dot(vecGravityDirection)
	var vecPlanarVelocity: Vector3 = oPlayer.velocity - vecGravityVelocity
	
	if vecMoveDir != Vector3.ZERO:
		vecPlanarVelocity = vecMoveDir * iMoveSpeed
	else:
		vecPlanarVelocity = vecPlanarVelocity.move_toward(Vector3.ZERO, iMoveSpeed * 0.15)
	
	oPlayer.velocity = vecPlanarVelocity + vecGravityVelocity

func UpdateOrientation(iDelta: float) -> void:
	var vecTargetUp: Vector3 = -vecGravityDirection.normalized()
	var vecCurrentForward: Vector3 = -oPlayer.global_transform.basis.z
	
	var vecTargetForward: Vector3 = vecCurrentForward.slide(vecGravityDirection).normalized()
	
	if vecTargetForward.length() < 0.001:
		vecTargetForward = Vector3.FORWARD.slide(vecGravityDirection).normalized()
	
	if vecTargetForward.length() < 0.001:
		vecTargetForward = Vector3.RIGHT.slide(vecGravityDirection).normalized()
	
	var vecTargetRight: Vector3 = vecTargetForward.cross(vecTargetUp).normalized()
	vecTargetForward = vecTargetUp.cross(vecTargetRight).normalized()
	
	var oTargetBasis: Basis = Basis(
		vecTargetRight,
		vecTargetUp,
		-vecTargetForward
	).orthonormalized()
	
	var qCurrent: Quaternion = oPlayer.global_transform.basis.get_rotation_quaternion()
	var qTarget: Quaternion = oTargetBasis.get_rotation_quaternion()
	
	var iWeight: float = clamp(iRotationSpeed * iDelta, 0.0, 1.0)
	var qResult: Quaternion = qCurrent.slerp(qTarget, iWeight)
	
	oPlayer.global_transform.basis = Basis(qResult).orthonormalized()
