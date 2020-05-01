extends CenterContainer

onready var playername = $PanelContainer/VBoxContainer/GridContainer/PlayerName
onready var ipaddress = $PanelContainer/VBoxContainer/GridContainer/IPAddress
onready var port = $PanelContainer/VBoxContainer/GridContainer/Port

signal join(player,ip,p)

func _on_Join_pressed():
	var player = playername.text
	var ip = ipaddress.text
	var p = port.text
	if player.empty():
		player = 'Player'
	if ip.empty():
		ip = '127.0.0.1'
	if p.empty():
		p = '36999'
	emit_signal("join", player, ip, p.to_int())
