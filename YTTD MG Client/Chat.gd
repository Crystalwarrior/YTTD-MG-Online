extends PanelContainer

onready var text = $VBoxContainer/ColorRect/RichTextLabel
onready var input = $VBoxContainer/LineEdit

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

func display_chat_message(msg, playername):
	var time = OS.get_time()
	var color = stringToColor(playername).to_html(false)
	newline_text('[color=gray]%s:%s[/color] [color=#%s][b]%s[/b][/color]: %s' % 
					[time.hour, time.minute, color, playername, msg])

func validate_chat(msg):
	if msg.empty():
		return false
	return true

func stringToColor(string, mix = Color.white, mixcoeff = 0.35):
	seed(string.hash())
	var color = Color.from_hsv(randf(), randf()*1.5, randf())

	# mix the color
	if (mix != null):
		color.r = color.r * (1 - mixcoeff) + mix.r * mixcoeff
		color.g = color.g * (1 - mixcoeff) + mix.g * mixcoeff
		color.b = color.b * (1 - mixcoeff) + mix.b * mixcoeff

	return color
