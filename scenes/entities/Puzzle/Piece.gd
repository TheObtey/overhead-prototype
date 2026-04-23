extends Node

@export var PosX = 0
@export var PosY = 0
@export var PosZ = 0
var pHolder: CharacterBody3D
var my_nodes_local_position = $MyNode.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	OnrangeOfFrame()
	
func OnrangeOfFrame() -> void:
	if my_nodes_local_position[0] < 7 and my_nodes_local_position [0] > 6 and my_nodes_local_position[1] < 3 and my_nodes_local_position [1] > 2 and my_nodes_local_position[2] < -9 and my_nodes_local_position [2] > -10 :
		my_nodes_local_position[0] = PosX
		my_nodes_local_position[1] = PosY 
		my_nodes_local_position[2] = PosZ
	else :
		return
