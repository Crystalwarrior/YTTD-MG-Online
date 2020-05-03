extends PanelContainer

onready var playerlist = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	Network.connect("player_registered", self, "_on_player_registered")
	Network.connect("player_unregistered", self, "_on_player_unregistered")

func _on_player_registered(id):
	playerlist.add_item(Network.players[id])

func _on_player_unregistered(id):
	playerlist.remove_item(Network.players[id])
