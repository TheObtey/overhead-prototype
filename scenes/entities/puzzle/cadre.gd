extends Node3D

@onready var sm_sr_locker_door: MeshInstance3D = $Visuals/SM_SR_Locker_Door
var iPuzzle_placed = 0
@onready var resolve_1: Node3D = $Resolve1
@onready var resolve_2: Node3D = $Resolve2

func Interactkey() -> void:
	
	iPuzzle_placed += 1

	if iPuzzle_placed == 2:
		resolve_1.visible = false
		resolve_2.visible = false
		sm_sr_locker_door.toggle_door()
