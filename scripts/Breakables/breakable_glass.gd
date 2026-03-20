extends RigidBody3D

@export var break_impact_threshold: float = 3.0
@export var destroy_on_break: bool = true

var is_broken: bool = false
var previous_speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	previous_speed = linear_velocity.length()

func _on_body_entered(body: Node) -> void:
	if is_broken:
		return
	
	var self_impact_speed: float = previous_speed
	var body_impact_speed: float = 0.0
	
	if body is RigidBody3D:
		body_impact_speed = body.linear_velocity.length()
	
	var impact_speed: float = max(self_impact_speed, body_impact_speed)
	
	if impact_speed >= break_impact_threshold:
		break_glass()

func break_glass() -> void:
	if is_broken:
		return
	
	is_broken = true
	
	if destroy_on_break:
		queue_free()
