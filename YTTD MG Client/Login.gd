extends CenterContainer

onready var playername = $PanelContainer/VBoxContainer/GridContainer/PlayerName
onready var ipaddress = $PanelContainer/VBoxContainer/GridContainer/IPAddress
onready var port = $PanelContainer/VBoxContainer/GridContainer/Port
onready var infolabel = $PanelContainer/VBoxContainer/InfoLabel

signal join(player,ip,p)

func _ready():
	Network.connect("connection_failed", self, "_on_failed")

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
	
	#Todo: check the validity of the playername on the serverside too
	if player.length() < 3:
		infolabel.text = "Playername too short!"
		return
	if not ip.is_valid_ip_address():
		infolabel.text = "Invalid IP Address!"
		return
	if not p.is_valid_integer():
		infolabel.text = "Invalid port!"
		return
	emit_signal("join", player, ip, p.to_int())
	infolabel.text = "Connecting..."

func _on_failed():
	infolabel.text = "Connection failed!"
