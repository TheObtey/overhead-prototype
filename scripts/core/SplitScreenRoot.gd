class_name SplitScreenRoot
extends CanvasLayer

@onready var oViewportP1: SubViewport = $VBoxContainer/Player1View/ViewportP1
@onready var oViewportP2: SubViewport = $VBoxContainer/Player2View/ViewportP2

var oViewportCameraP1: Camera3D
var oViewportCameraP2: Camera3D

var oPlayer1: Node
var oPlayer2: Node

var oSourceCameraP1: Camera3D
var oSourceCameraP2: Camera3D

func _ready() -> void:
	_CreateViewportCameras()

func _process(_iDelta: float) -> void:
	_SyncViewportCameras()

func Setup(oNewPlayer1: Node, oNewPlayer2: Node) -> void:
	oPlayer1 = oNewPlayer1
	oPlayer2 = oNewPlayer2
	
	oSourceCameraP1 = _FindPlayerCamera(oPlayer1)
	oSourceCameraP2 = _FindPlayerCamera(oPlayer2)
	
	if oSourceCameraP1 != null:
		oSourceCameraP1.current = false
	
	if oSourceCameraP2 != null:
		oSourceCameraP2.current = false

func _CreateViewportCameras() -> void:
	oViewportCameraP1 = Camera3D.new()
	oViewportCameraP1.name = "ViewportCameraP1"
	oViewportP1.add_child(oViewportCameraP1)
	
	oViewportCameraP2 = Camera3D.new()
	oViewportCameraP2.name = "ViewportCameraP2"
	oViewportP2.add_child(oViewportCameraP2)
	
	oViewportCameraP1.current = true
	oViewportCameraP2.current = true

func _FindPlayerCamera(oPlayer: Node) -> Camera3D:
	if oPlayer == null:
		return null
	
	var oCamera = oPlayer.find_child("Camera3D", true, false)
	if oCamera is Camera3D:
		return oCamera
	
	return null

func _SyncViewportCameras() -> void:
	if oSourceCameraP1 != null:
		oViewportCameraP1.global_transform = oSourceCameraP1.global_transform
		oViewportCameraP1.fov = oSourceCameraP1.fov
		oViewportCameraP1.near = oSourceCameraP1.near
		oViewportCameraP1.far = oSourceCameraP1.far
		oViewportCameraP1.cull_mask = oSourceCameraP1.cull_mask
	
	if oSourceCameraP2 != null:
		oViewportCameraP2.global_transform = oSourceCameraP2.global_transform
		oViewportCameraP2.fov = oSourceCameraP2.fov
		oViewportCameraP2.near = oSourceCameraP2.near
		oViewportCameraP2.far = oSourceCameraP2.far
		oViewportCameraP2.cull_mask = oSourceCameraP2.cull_mask
