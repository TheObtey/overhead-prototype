class_name LocalGameInitializer
extends Node

@export var iPlayerCount: int = 2

@onready var oSpawner: LocalPlayerSpawner = $"../LocalPlayerSpawner"

func _ready() -> void:
	var tPlayers = StartLocalGame()
	
	if tPlayers.is_empty():
		return
	
	var oCamera = tPlayers[0].find_child("Camera3D", true, false)
	if oCamera is Camera3D:
		oCamera.current = true

func StartLocalGame() -> Array[Node]:
	var tPlayers = oSpawner.SpawnLocalPlayers(iPlayerCount)
	return tPlayers
