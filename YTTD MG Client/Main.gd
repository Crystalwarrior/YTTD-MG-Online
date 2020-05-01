extends Control


func _ready():
	get_tree().connect("connected_to_server", self, "enter_room")

func join_room(ip, port):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, port)
	get_tree().set_network_peer(host)


func enter_room():
	$Login.hide()
	$GameWindow.show()
	print("nice")


func leave_room():
	$Login.show()
	$GameWindow.hide()
	get_tree().set_network_peer(null)


func _on_Login_join(player, ip, p):
	join_room(ip, p)
