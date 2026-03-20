extends Node3D


@export_category("Holding Object")
@export var Can_Holding_Object = false
@export var throwForce = 7.5
@export var followSpeed = 5.0
@export var followDistance = 2.5
@export var maxDistanceFromCamera = 5.0
@export var dropBellowPlayer = false
@export var groundRay: RayCast3D

@onready var mesh_gun: MeshInstance3D = $MeshGun
@onready var interactRay: RayCast3D = $MeshGun/InteractRay
var heldObject: RigidBody3D


func set_held_object(body: RigidBody3D):
	if body is RigidBody3D:
		heldObject = body

func drop_held_object():
	heldObject = null

func throw_held_object():
	var obj = heldObject
	drop_held_object()
	obj.apply_central_impulse(-mesh_gun.global_transform.basis.z * throwForce *10)



func handle_holding_object():
	if Can_Holding_Object:
		
		if Input.is_action_just_pressed("throw"):
			if heldObject != null: throw_held_object()
			
		if Input.is_action_just_pressed("interact"):
			if heldObject != null: drop_held_object()
			elif interactRay.is_colliding(): set_held_object(interactRay.get_collider())
			
		if heldObject != null:
			var targetPos =mesh_gun.global_transform.origin + (mesh_gun.global_basis * Vector3(0, 0, -followDistance))
			var objectPos = heldObject.global_transform.origin
			heldObject.linear_velocity = ( targetPos - objectPos) * followSpeed
			
			if heldObject.global_position.distance_to(mesh_gun.global_position) > maxDistanceFromCamera:
				drop_held_object()
			
			if dropBellowPlayer && groundRay.is_colliding():
				if groundRay.get_collider() == heldObject: drop_held_object() 
			
