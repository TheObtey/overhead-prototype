class_name LocalGameInitializer
extends Node

@onready var oSpawner: LocalPlayerSpawner = $"../LocalPlayerSpawner"
@onready var oSplitScreenRoot: SplitScreenRoot = $"../SplitScreenRoot"

func _ready() -> void:
	if not LocalSession.IsSessionReady():
		push_error("LocalGameInitializer: no active local session")
		return
	
	var tBindings = LocalSession.GetBindings()
	var iPlayerCount = LocalSession.GetPlayerCount()
	
	LocalInputRouter.ConfigureBindings(tBindings)
	
	var tPlayers = oSpawner.SpawnLocalPlayers(iPlayerCount)
	if tPlayers.is_empty():
		return
	
	if oSplitScreenRoot != null and tPlayers.size() >= 2:
		oSplitScreenRoot.Setup(tPlayers[0], tPlayers[1])
