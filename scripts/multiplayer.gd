extends Control

@onready var host = $main/host
@onready var join = $main/join
@onready var restart_button = $main/restart_button
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _ready():
	restart_button.visible = false

func _on_host_pressed():
	host.visible = false
	join.visible = false
	peer.create_server(6006)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	restart_button.visible = true

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)

func _on_join_pressed():
	host.visible = false
	join.visible = false
	peer.create_client("localhost", 6006)
	multiplayer.multiplayer_peer = peer
	restart_button.visible = true
