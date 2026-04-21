class_name LocalPlayerSpawner
extends Node

@export var oPlayerScene: PackedScene
@export var oSpawnPointsPath: NodePath

func GetSpawnPoints() -> Array[Node3D]:
	var tPoints: Array[Node3D] = []
	
	var oContainer = get_node_or_null(oSpawnPointsPath)
	if oContainer == null:
		push_error("LocalPlayerSpawner: SpawnPoints container not found")
		return tPoints
	
	for oChild in oContainer.get_children():
		if oChild is Node3D:
			tPoints.append(oChild)
	
	return tPoints

func SpawnLocalPlayers(iPlayerCount: int) -> Array[Node]:
	var tSpawnedPlayers: Array[Node] = []
	var tSpawnPoints = GetSpawnPoints()
	
	if oPlayerScene == null:
		push_error("LocalPlayerSpawner: PlayerScene is not assigned")
		return tSpawnedPlayers
	
	if tSpawnPoints.size() < iPlayerCount:
		push_error("LocalPlayerSpawner: Not enough spawn points for players")
		return tSpawnedPlayers
	
	for i in range(iPlayerCount):
		var oPlayerInstance = oPlayerScene.instantiate()
		var oSpawnPoint = tSpawnPoints[i]
		
		var sPlayerNumber: String = str(i + 1)
		var sViewportPath = "SplitScreenRoot/VBoxContainer/Player" + sPlayerNumber + "View/ViewportP" + sPlayerNumber
		var oPlayerViewport = get_parent().get_node_or_null(sViewportPath)
		
		print(sViewportPath, oPlayerViewport)
		
		if oPlayerViewport != null:
			oPlayerViewport.add_child.call_deferred(oPlayerInstance)
		
		oPlayerInstance.global_transform = oSpawnPoint.global_transform
		
		if oPlayerInstance.has_method("SetPlayerID"):
			oPlayerInstance.SetPlayerID(i)
		
		tSpawnedPlayers.append(oPlayerInstance)
	
	return tSpawnedPlayers
