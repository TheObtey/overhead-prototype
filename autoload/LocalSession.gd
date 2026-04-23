extends Node

var bIsLocalSessionActive: bool = false
var tPlayerBindings: Array[LocalPlayerDeviceBinding] = []
var iRequestedPlayerCount: int = 0

func Reset() -> void:
	bIsLocalSessionActive = false
	tPlayerBindings.clear()
	iRequestedPlayerCount = 0

func StartLocalSession(tBindings: Array[LocalPlayerDeviceBinding]) -> void:
	Reset()
	bIsLocalSessionActive = true
	tPlayerBindings = tBindings.duplicate()
	iRequestedPlayerCount = tPlayerBindings.size()

func IsSessionReady() -> bool:
	return bIsLocalSessionActive and iRequestedPlayerCount > 0 and tPlayerBindings.size() == iRequestedPlayerCount

func GetPlayerCount() -> int:
	return iRequestedPlayerCount

func GetBindings() -> Array[LocalPlayerDeviceBinding]:
	return tPlayerBindings.duplicate()
