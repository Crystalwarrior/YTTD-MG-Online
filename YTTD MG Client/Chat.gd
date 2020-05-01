extends PanelContainer

onready var text = $TabContainer/Current/ColorRect/RichTextLabel
onready var input = $TabContainer/Current/LineEdit

func _ready():
	pass

func append_text(msg):
	text.bbcode_text += msg

func newline_text(msg):
	text.bbcode_text += '\n%s' % msg

func set_text(msg):
	text.bbcode_text = msg

func _on_LineEdit_text_entered(new_text):
	display_chat_message(new_text, Settings.playername)
	input.clear()

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
