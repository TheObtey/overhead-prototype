extends RigidBody3D

# Physics object that can be picked up, carried, and thrown
# by a character while preserving gravity behavior.
@onready var oGravityReceiverComponent = $Components/GravityReceiverComponent

@export var bIsCarriable: bool = true
@export var iHoldDistance: float = 2.5
@export var iFollowSpeed: float = 12.0
@export var iThrowForce: float = 10.0

var pHolder: CharacterBody3D
var bIsHeld: bool = false

# --------------------------------------------------
# Initializes the carriable entity.
# Links the gravity receiver component to this body
# so it can apply custom gravity behavior correctly.
# --------------------------------------------------
func _ready() -> void:
	oGravityReceiverComponent.Setup(self)

# --------------------------------------------------
# Called when a player picks up the object.
# Stores the holder, marks the object as held,
# resets its current motion, and disables collision
# with the player while it is being carried.
# --------------------------------------------------
func OnPickedUp(pPlayer: CharacterBody3D) -> void:
	if not bIsCarriable:
		return
	
	pHolder = pPlayer
	bIsHeld = true
	
	freeze = false
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	SetCollisionWithPlayer(pPlayer, false)

# --------------------------------------------------
# Called when the object is released.
# Clears the held state, restores collision with the
# holder, and removes the holder reference.
# --------------------------------------------------
func OnDropped() -> void:
	bIsHeld = false
	
	SetCollisionWithPlayer(pHolder, true)
	
	pHolder = null

# --------------------------------------------------
# Throws the currently held object forward.
# Uses the holder orientation by default, but gives
# priority to the CameraRoot orientation if present
# so the throw follows the player's view direction.
# --------------------------------------------------
func Throw() -> void:
	if not bIsHeld:
		return
	
	var throw_basis: Basis = pHolder.global_transform.basis
	
	var oCameraRoot: Node3D = pHolder.get_node_or_null("CameraRoot")
	if 	oCameraRoot != null:
		throw_basis = oCameraRoot.global_transform.basis
	
	var vecForward: Vector3 = -throw_basis.z
	linear_velocity = vecForward * iThrowForce
	
	OnDropped()

# --------------------------------------------------
# Updates the object every physics frame while held.
# If the object is currently carried, it continuously
# moves toward its target hold position.
# --------------------------------------------------
func _physics_process(iDelta: float) -> void:
	if not bIsHeld or not pHolder:
		return
	
	UpdateHeldPosition(iDelta)

# --------------------------------------------------
# Moves the held object toward a target position in
# front of the player's camera.
# The object follows the camera using velocity,
# creating a smooth carrying behavior.
# --------------------------------------------------
func UpdateHeldPosition(iDelta: float) -> void:
	var oCamera: Camera3D = pHolder.get_node("CameraRoot/Camera3D")
	
	var vecTargetPos: Vector3 = (
		oCamera.global_transform.origin +
		(-oCamera.global_transform.basis.z * iHoldDistance)
	)
	
	var vecDir: Vector3 = vecTargetPos - global_transform.origin
	linear_velocity = vecDir * iFollowSpeed


# --------------------------------------------------
# Enables or disables collision between the carried
# object and the player holding it.
# This is used to avoid unwanted physics interference
# while carrying the object.
# --------------------------------------------------
func SetCollisionWithPlayer(pPlayer: CharacterBody3D, bEnable: bool) -> void:
	if not pPlayer:
		return
	
	#if bEnable: TODO: Replace this by the real value
		#set_collision_layer_value(1, true)
	#else:
		#set_collision_layer_value(1, false)
