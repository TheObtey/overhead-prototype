extends Node3D

@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var light : SpotLight3D = $SpotLight3D
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
			HidePing()
	

func LinkPing(iPlayerId : int) -> void:
	match iPlayerId:
		0:
			mesh.material_override = material1
			light.light_color = Color(158, 64, 233, 1.0)
		1:
			mesh.material_override = material2
			light.light_color = Color(219,232,63, 1.0)
	pass

func HidePing() -> void:
	self.visible = false
	iTimeDisplayed = 0.0
	pass

# iPlayerID : player 1 : 0 - player2 : 1 ping Color
func DisplayPing() -> void :
	self.visible = true
	iTimeDisplayed = 10.0
	pass
