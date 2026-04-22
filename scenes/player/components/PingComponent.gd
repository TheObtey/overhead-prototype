extends Node

@onready var mesh : MeshInstance3D = $Visual/MeshInstance3D
@onready var light : SpotLight3D = $Visual/SpotLight3D
@onready var visual : Node3D = $Visual
@onready var oRaycast : RayCast3D = $"../../CameraRoot/RayCast3D"

@export var material1 : Material
@export var material2 : Material

@onready var iTimeDisplayed : float = 0.0
@onready var bIsDisplay : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(iDelta: float) -> void:
	if bIsDisplay:
		iTimeDisplayed -= iDelta
		if iTimeDisplayed <= 0.0:
			RemovePing()
	

func HandleInput() -> void :
	
	pass

func LinkPing(iPlayerId : int) -> void:
	match iPlayerId:
		0:
			mesh.material_override = material1
			light.light_color = Color(158, 64, 233, 1.0)
		1:
			mesh.material_override = material2
			light.light_color = Color(219,232,63, 1.0)
	pass

func RemovePing() -> void:
	visual.visible = false
	bIsDisplay = false
	iTimeDisplayed = 0.0
	pass

# iPlayerID : player 1 : 0 - player2 : 1 ping Color
func Ping() -> void :
	visual.visible = true
	bIsDisplay = true
	var pingPos : Vector3 = oRaycast.position + oRaycast.target_position
	if oRaycast.is_colliding():
		pingPos = oRaycast.get_collision_point()
	self.position = pingPos
	iTimeDisplayed = 10.0
	pass
