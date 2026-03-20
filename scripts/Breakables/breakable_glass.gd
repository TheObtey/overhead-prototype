extends Node3D

@export var break_impact_threshold: float = 1.0
@export var destroy_on_break: bool = true

@onready var hit_area: Area3D = $HitArea

var is_broken: bool = false

func _ready() -> void:
	hit_area.body_entered.connect(_on_hit_area_body_entered)

func _on_hit_area_body_entered(body: Node3D) -> void:
	if is_broken:
		return
	
	var impact_speed: float = 0.0
	
	if body is RigidBody3D:
		impact_speed = body.linear_velocity.length()
	else:
		return
	
	print("Glass impact speed: ", impact_speed)
	
	if impact_speed >= break_impact_threshold:
		break_glass()

func break_glass() -> void:
	if is_broken:
		return
	
	is_broken = true
	
	if destroy_on_break:
		queue_free()
