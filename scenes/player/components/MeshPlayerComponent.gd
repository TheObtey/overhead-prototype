extends Node

@onready var oHead: MeshInstance3D = $charNode01/model01/Bob_Head_Grp/Bob_Head
@onready var oGlasB: MeshInstance3D = $charNode01/globalMove01/joints01/Skeleton3D/Glass_Bubble
@onready var oMainBody: MeshInstance3D = $charNode01/globalMove01/joints01/Skeleton3D/Main_Body
@onready var oShoeL: MeshInstance3D = $charNode01/globalMove01/joints01/Skeleton3D/Shoe_L
@onready var oShoeR: MeshInstance3D = $charNode01/globalMove01/joints01/Skeleton3D/Shoe_R

@export var oMesh1: Mesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SetPlayerID(iPlayerID: int) -> void:
	
	match iPlayerID:
		1:
			oHead.mesh = oMesh1
			
	SetCullMaskOfElements(2+iPlayerID)
	pass
	
func SetCullMaskOfElements(iCullMaskID : int) -> void:
	oHead.set_layer_mask_value(iCullMaskID,true)
	oGlasB.set_layer_mask_value(iCullMaskID,true)
	oMainBody.set_layer_mask_value(iCullMaskID,true)
	oShoeL.set_layer_mask_value(iCullMaskID,true)
	oShoeR.set_layer_mask_value(iCullMaskID,true)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
