class_name LocalGameInitializer
extends Node

@export var iPlayerCount: int = 2

@onready var oSpawner: LocalPlayerSpawner = $"../LocalPlayerSpawner"
@onready var oSplitScreenRoot: SplitScreenRoot = $"../SplitScreenRoot"

func _ready() -> void:
	var tPlayers = StartLocalGame()
	
	if tPlayers.is_empty():
		return
	
	if oSplitScreenRoot != null:
		oSplitScreenRoot.Setup(tPlayers[0], tPlayers[1])

func StartLocalGame() -> Array[Node]:
	var tPlayers = oSpawner.SpawnLocalPlayers(iPlayerCount)
	return tPlayers
