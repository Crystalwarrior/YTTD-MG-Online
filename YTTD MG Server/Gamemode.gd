extends Node


onready var Network = $"/root/Network"
onready var timer = $Timer
onready var progressbar = $ProgressBar

#time in seconds
var phases = [
	{"name": "lobby", "time": 15},
	{"name": "intro", "time": 5},
	{"name": "preliminary", "time": 5},
	{"name": "prevote", "time": 5},
	{"name": "finals", "time": 5},
	{"name": "finalvote", "time": 5},
	{"name": "results", "time": 5},
]

enum Outcome {EVERYONE_DIES, WIN_AND_PICK, WIN_ALONE, LOSE, NOBODY_DIES}

var current_phase = 0
var roles = {
	"keymaster": {
		"priority": 0, #lower number = higher priority
		"votes": 1, #number of votes this role can do
		"majority": Outcome.EVERYONE_DIES, #the outcome of majority vote on this role
		"color": "gold",
	},
	"sacrfice": {
		"priority": 1, #lower number = higher priority
		"votes": 2, #number of votes this role can do
		"majority": Outcome.WIN_AND_PICK, #the outcome of majority vote on this role
		"color": "crimson",
	},
	"sage": {
		"priority": 2, #lower number = higher priority
		"votes": 1, #number of votes this role can do
		"majority": Outcome.LOSE, #the outcome of majority vote on this role
		"color": "deepskyblue",
	},
	"commoner": {
		"priority": 3, #lower number = higher priority
		"votes": 1, #number of votes this role can do
		"majority": Outcome.LOSE, #the outcome of majority vote on this role
		"color": "mediumseagreen",
	},
}
var min_participants = 5
var participants = [] #{name: "guy", "id": 12341413, role: "sacrifice", votes: 0} #list of dictionaries containing all info pertaining to participants

func _process(delta):
	if progressbar.max_value != $Timer.wait_time:
		progressbar.max_value = $Timer.wait_time
	progressbar.value = timer.time_left

func add_participant(Name, id):
	participants.append({"name": Name, "id": id, "role": "", "votes": 0})

func clear_votes():
	for player in participants:
		player.votes = 0

func get_participant_name(_name):
	for player in participants:
		if player.name == _name:
			return player

func get_participant_id(id):
	for player in participants:
		if player.id == id:
			return player

func assign_roles():
	var _roles = roles.keys()
	while _roles.size() < participants.size():
		_roles.append(_roles.back())
	randomize()
	_roles.shuffle()
	for i in range(participants.size()):
		participants[i].role = _roles[i]
		Network.send_server_message_id(participants[i].id, "[color=grey]Your role is [color=%s]%s[/color].[/color]" % [roles[participants[i].role].color, participants[i].role])
	print(participants)

class MGSorter:
	static func votes_highest(a, b):
		if a["votes"] < b["votes"]:
			return true
		return false
	static func votes_lowest(a, b):
		if a["votes"] > b["votes"]:
			return true
		return false

func next_phase():
	current_phase = (current_phase + 1) % phases.size()
	$Timer.wait_time = phases[current_phase].time
	$Timer.start()
	if has_method("phase_%s_start" % phases[current_phase].name):
		call("phase_%s_start" % phases[current_phase].name)

	Network.send_server_message(
		"[color=grey]Current phase is [color=lime]%s[/color]. It will last %s seconds.[/color]"
		 % [phases[current_phase].name, phases[current_phase].time])

func phase_lobby_end():
	if Network.players.size() < min_participants:
		Network.send_server_message(
			"[color=grey]Not enough participants (%s out of %s)! [color=lime]%s[/color] phase extended for %s seconds.[/color]"
			 % [Network.players.size(), min_participants, phases[current_phase].name, phases[current_phase].time])
		$Timer.wait_time = phases[current_phase].time
		$Timer.start()
	else:
		next_phase()

func phase_intro_start():
	for p_id in Network.players:
		add_participant(Network.players[p_id], p_id) #name, id
	assign_roles()

func phase_results_end():
	participants.clear()
	next_phase()

func _on_Timer_timeout():
	if has_method("phase_%s_end" % phases[current_phase].name):
		call("phase_%s_end" % phases[current_phase].name)
	else:
		next_phase()
