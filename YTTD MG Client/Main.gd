extends Control


func _ready():
	Network.connect("connection_succeeded", self, "_enter_room")
	Network.connect("server_disconnected", self, "_leave_room")

func _enter_room():
	$Login.hide()
	$GameWindow.show()


func _leave_room():
	$Login.show()
	$GameWindow.hide()


func _on_Login_join(player, ip, p):
	Network.my_name = player
	Network.connect_to_server(ip, p)
