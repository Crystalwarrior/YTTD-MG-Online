extends Node

# Signal to let GUI know whats up
signal connection_failed()
signal connection_succeeded()
signal server_disconnected()
signal player_registered(id)
signal player_unregistered(id)
signal chat_message_received(pname, msg)

var my_name = "Player"

var players = {} #players dict id:name


func _ready():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func connect_to_server(ip, port):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, port)
	get_tree().set_network_peer(host)


# Callback from SceneTree, called when connect to server
func _connected_ok():
	# Register ourselves with the server
	rpc_id(1, "register_player", my_name)
	emit_signal("connection_succeeded")


# Callback from SceneTree, called when server disconnect
func _server_disconnected():
	players.clear()
	emit_signal("server_disconnected")


# Callback from SceneTree, called when unabled to connect to server
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")


puppet func register_player(id, new_player_data):
	players[id] = new_player_data
	emit_signal("player_registered", id)

puppet func unregister_player(id):
	emit_signal("player_unregistered", id)
	players.erase(id)

remote func receive_message(pname, msg):
	emit_signal("chat_message_received", pname, msg)

func send_message(msg):
	rpc_id(1, "receive_message", msg)
