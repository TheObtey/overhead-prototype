extends Node

const PORT := 7000
const MAX_CLIENTS := 2
const PLAYER_SCENE := preload("res://scenes/player.tscn")

@rpc("any_peer", "unreliable")
func rpc_receive_player_transform(iPeerID: int, vecPos: Vector3, vecRot: Vector3):
	var players_node = get_tree().current_scene.get_node("Players")
	var pPlayer = players_node.get_node_or_null(str(iPeerID))
	
	if pPlayer == null:
		return
	
	if pPlayer.is_multiplayer_authority():
		return
	
	pPlayer.global_position = vecPos
	pPlayer.global_rotation = vecRot

func send_player_transform(vecPos: Vector3, vecRot: Vector3):
	if multiplayer.multiplayer_peer == null:
		return
	
	rpc("rpc_receive_player_transform", multiplayer.get_unique_id(), vecPos, vecRot)

@rpc("authority", "call_local", "reliable")
func rpc_spawn_player(iPeerID: int, vecSpawnPosition: Vector3):
	if get_tree().current_scene.get_node("Players").has_node(str(iPeerID)):
		return
	
	spawn_player(iPeerID, vecSpawnPosition)

func spawn_player(iPeerID: int, vecSpawnPosition: Vector3):
	var pPlayer = PLAYER_SCENE.instantiate()
	pPlayer.name = str(iPeerID)
	pPlayer.set_multiplayer_authority(iPeerID)
	
	# Debug shit
	print(iPeerID, pPlayer)
	
	get_tree().current_scene.get_node("Players").add_child(pPlayer)
	pPlayer.global_position = vecSpawnPosition

@rpc("any_peer", "reliable")
func request_existing_players():
	if not multiplayer.is_server():
		return
	
	for pPlayer in get_tree().current_scene.get_node("Players").get_children():
		rpc_spawn_player.rpc_id(
			multiplayer.get_remote_sender_id(),
			int(pPlayer.name),
			pPlayer.global_position
		)

func host_game():
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(PORT, MAX_CLIENTS)
	
	if error != OK:
		print("Error when creating server: ", error)
		return
		
	multiplayer.multiplayer_peer = peer
	
	print("Server active on port: ", PORT)
	print("My peer ID: ", multiplayer.get_unique_id())
	
	rpc_spawn_player.rpc(multiplayer.get_unique_id(), Vector3(-2, 2, 0))

func join_game(sServerIp: String):
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(sServerIp, PORT)
	
	if error != OK:
		print("Connection failed: ", error)
		return
	
	multiplayer.multiplayer_peer = peer
	
	print("Joining server: ", sServerIp)

func stop_game():
	if multiplayer.multiplayer_peer == null:
		return
	
	var peer = multiplayer.multiplayer_peer
	multiplayer.multiplayer_peer = null
	peer.close()
	
	for pPlayer in get_tree().current_scene.get_node("Players").get_children():
		pPlayer.set_process(false)
		pPlayer.set_physics_process(false)
	
	get_tree().call_group("players", "queue_free")

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func _on_peer_connected(iPeerID: int):
	print("Peer connected: ", iPeerID)
	
	if multiplayer.is_server():
		rpc_spawn_player.rpc(iPeerID, Vector3(2, 2, 0))

func _on_peer_disconnected(iPeerID: int):
	print("Peer disconnected: ", iPeerID)
	stop_game();

func _on_connected_to_server():
	print("Connected to server")
	
	await get_tree().process_frame
	rpc_id(1, "request_existing_players")

func _on_connection_failed():
	print("Connection failed")

func _on_server_disconnected():
	print("Disconnected from server")



# Debug area
func _input(event):
	if event.is_action_pressed("ui_accept"): # 'Enter' to start server
		host_game()
	
	if event.is_action_pressed("ui_cancel"): # 'Escape' to join server
		join_game("127.0.0.1")
