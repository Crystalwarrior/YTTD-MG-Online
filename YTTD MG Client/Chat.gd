extends PanelContainer

onready var text = $TabContainer/Current/ColorRect/RichTextLabel
onready var input = $TabContainer/Current/LineEdit

func _ready():
	Network.connect("chat_message_received", self, "_on_chat_message_received")

func append_text(msg):
	text.bbcode_text += msg

func newline_text(msg):
	text.bbcode_text += '\n%s' % msg

func set_text(msg):
	text.bbcode_text = msg

func _on_LineEdit_text_entered(new_text):
	Network.send_message(new_text)
	input.clear()

func _on_chat_message_received(id, msg):
	var playername
	if id == get_tree().get_network_unique_id():
		playername = Network.my_name
	else:
		playername = Network.players[id]
	display_chat_message(msg, playername)

func display_message(msg):
	var time = OS.get_time()
	newline_text('[color=gray]%s:%s[/color] %s' % 
					[time.hour, time.minute, msg])

func display_chat_message(msg, playername):
	var color = stringToColor(playername).to_html(false)
	display_message('[color=#%s][b]%s[/b][/color]: %s' % [color, playername, msg])
	if Settings.chatsfx:
		$"/root/Main/Sfx".play()

func stringToColor(string, mix = Color.white, mixcoeff = 0.35):
	var color = Color(string.hash() & 0xffffff)

	# mix the color
	if (mix != null):
		color.r = color.r * (1 - mixcoeff) + mix.r * mixcoeff
		color.g = color.g * (1 - mixcoeff) + mix.g * mixcoeff
		color.b = color.b * (1 - mixcoeff) + mix.b * mixcoeff

	return color

func validate_chat(msg):
	if msg.empty():
		return false
	return true
