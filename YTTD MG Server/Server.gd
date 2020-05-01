extends Node

const PORT = 36999
const MAX_USERS = 100 #not including host

func _ready():
	get_tree().connect("network_peer_connected", self, "user_entered")
	get_tree().connect("network_peer_disconnected", self, "user_exited")
	host_room()

func host_room():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAX_USERS)
	get_tree().set_network_peer(host)
	print("Hosting on port %s" % PORT)

func user_entered(id):
	print("%s joined the room" % id)

func user_exited(id):
	print("%s left the room" % id)

remote func receive_message(id, msg):
	print("%s: %s" % [id, msg])
#
#func send_message(msg):
#	rpc("receive_message", 1, msg)
