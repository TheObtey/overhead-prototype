extends EquippableItemBase

@export var iPickupDistance: float = 5.0

var eHeldEntity: RigidBody3D

func _ready() -> void:
	sItemName = "Gravity Gun"

func OnPrimaryAction() -> void:
	if eHeldEntity:
		DropEntity()
	else:
		TryPickup()

func OnSecondaryAction() -> void:
	if not eHeldEntity:
		return
	
	eHeldEntity.Throw()
	eHeldEntity = null

func TryPickup() -> void:
	var oCamera: Camera3D = pOwner.get_node("CameraRoot/Camera3D")
	
	var vecFrom: Vector3 = oCamera.global_transform.origin
	var vecTo: Vector3 = vecFrom + (-oCamera.global_transform.basis.z * iPickupDistance)
	
	var oSpace = pOwner.get_world_3d().direct_space_state
	var oQuery = PhysicsRayQueryParameters3D.create(vecFrom, vecTo)
	
	var oResult = oSpace.intersect_ray(oQuery)
	
	if not oResult:
		return
	
	var oCollider = oResult.collider
	
	if not oCollider or not oCollider.has_method("OnPickedUp"):
		return
	
	eHeldEntity = oCollider
	eHeldEntity.OnPickedUp(pOwner)

func DropEntity() -> void:
	if not eHeldEntity:
		return
	
	eHeldEntity.OnDropped()
	eHeldEntity = null
