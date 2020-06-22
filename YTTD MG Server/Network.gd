extends Node

const PORT = 36999
const MAX_USERS = 100 #not including host

const MAX_CHAT_LENGTH = 128

var players = {} #players dict id:name

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

	create_server()

func create_server():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAX_USERS)
	get_tree().set_network_peer(host)
	print("Hosting on port %s" % PORT)

func _player_connected(id):
	print("%s is connecting..." % id)

func _player_disconnected(id):
	if players.has(id):
		rpc("unregister_player", id)
	print("%s has disconnected." % id)

# Player management functions
remote func register_player(new_player_name):
	# We get id this way instead of as parameter, to prevent users from pretending to be other users
	var caller_id = get_tree().get_rpc_sender_id()
	
	# Add him to our list
	players[caller_id] = new_player_name
	
	# Add everyone to new player:
	for p_id in players:
		rpc_id(caller_id, "register_player", p_id, players[p_id]) # Send each player to new dude
		if p_id != caller_id:
			rpc_id(p_id, "register_player", caller_id, players[caller_id]) # Send new dude to all players

	send_server_message("[color=gray]Player '%s' has joined the server.[/color]" % players[caller_id])
	print("Client ", caller_id, " registered as ", new_player_name)

puppetsync func unregister_player(id):
	send_server_message("[color=gray]Player '%s' has left the server.[/color]" % players[id])
	players.erase(id)
	print("Client ", id, " was unregistered")

remote func receive_message(msg):
	var caller_id = get_tree().get_rpc_sender_id()
	if not players.has(caller_id):
		print('Unknown ID %s!' % caller_id)
		return
	msg = msg.strip_escapes()
	msg = msg.strip_edges()
	msg = strip_bbcode(msg)
	msg = msg.left(MAX_CHAT_LENGTH) #limit the string size
	if msg.empty():
		return
	print("%s: %s" % [players[caller_id], msg])
	rpc("receive_message", players[caller_id], msg) #send the message to all players

func send_server_message(msg):
	rpc("receive_message", "", msg)
	print(msg)

func send_server_message_id(id, msg):
	rpc_id(id, "receive_message", "", msg)

func strip_bbcode(msg):
	var regex = RegEx.new()
	regex.compile('\\[\\/?[^ \\/\\]]*]')
	msg = regex.sub(msg, '', true)
	return msg
