extends RigidBody3D

@onready var oGravityReceiverComponent = $Components/GravityReceiverComponent

@export var bIsCarriable: bool = true
@export var iHoldDistance: float = 2.5
@export var iFollowSpeed: float = 12.0
@export var iThrowForce: float = 10.0

var pHolder: CharacterBody3D
var bIsHeld: bool = false

func _ready() -> void:
	oGravityReceiverComponent.Setup(self)

func OnPickedUp(pPlayer: CharacterBody3D) -> void:
	if not bIsCarriable:
		return
	
	pHolder = pPlayer
	bIsHeld = true
	
	freeze = false
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	SetCollisionWithPlayer(pPlayer, false)

func OnDropped() -> void:
	bIsHeld = false
	
	SetCollisionWithPlayer(pHolder, true)
	
	pHolder = null

func Throw() -> void:
	if not bIsHeld:
		return
	
	var vecForward: Vector3 = -pHolder.global_transform.basis.z
	linear_velocity = vecForward * iThrowForce
	
	OnDropped()

func _physics_process(iDelta: float) -> void:
	if not bIsHeld or not pHolder:
		return
	
	UpdateHeldPosition(iDelta)

func UpdateHeldPosition(iDelta: float) -> void:
	var oCamera: Camera3D = pHolder.get_node("CameraRoot/Camera3D")
	
	var vecTargetPos: Vector3 = (
		oCamera.global_transform.origin +
		(-oCamera.global_transform.basis.z * iHoldDistance)
	)
	
	var vecDir: Vector3 = vecTargetPos - global_transform.origin
	linear_velocity = vecDir * iFollowSpeed

func SetCollisionWithPlayer(pPlayer: CharacterBody3D, bEnable: bool) -> void:
	if not pPlayer:
		return
	
	#if bEnable: TODO: Replace this by the real value
		#set_collision_layer_value(1, true)
	#else:
		#set_collision_layer_value(1, false)
