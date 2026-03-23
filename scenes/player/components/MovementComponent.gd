extends Node

@export var move_speed: float = 6.0
@export var jump_velocity: float = 5.0
@export var gravity_strength: float = 19.0

var player: CharacterBody3D
var gravity_direction: Vector3 = Vector3.DOWN

func setup(p_player: CharacterBody3D) -> void:
	player = p_player

func physics_update(iDelta: float) -> void:
	apply_gravity(iDelta)
	handle_jump()
	handle_movement()
	player.move_and_slide()

func apply_gravity(iDelta: float) -> void:
	if not player.is_on_floor():
		player.velocity += gravity_direction * gravity_strength * iDelta

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity -= gravity_direction * jump_velocity

func handle_movement() -> void:
	var vecInputDir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	var vecForward: Vector3 = player.global_transform.basis.z
	var vecRight: Vector3 = player.global_transform.basis.x
	
	vecForward.y = 0.0
	vecRight.y = 0.0
	
	vecForward = vecForward.normalized()
	vecRight = vecRight.normalized()
	
	var vecMoveDir: Vector3 = (vecRight * vecInputDir.x + vecForward * vecInputDir.y).normalized()
	
	if vecMoveDir != Vector3.ZERO:
		player.velocity.x = vecMoveDir.x * move_speed
		player.velocity.z = vecMoveDir.z * move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, move_speed)
		player.velocity.z = move_toward(player.velocity.z, 0.0, move_speed)
