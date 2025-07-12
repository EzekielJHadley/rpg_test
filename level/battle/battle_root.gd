extends Level_root

var current_char: Character = null
var current_target: Dictionary = {"index":0, "targets":[], "team":"Enemies"}
var character_list: Dictionary = {"Allies":[], "Enemies":[]}
var turn_order: Array = []
var num_fighters: Dictionary = {"Allies":0, "Enemies":0}
var interupt: bool = false
var interupt_signal:Signal
var select_mode: bool = false
var selected_attack: Dictionary
var conv: Conversation

func _ready() -> void:
	add_players()
	calc_turn_order()
	for fighter: Character in turn_order:
		fighter.Event.connect(event_handler)
	$Combat.Event.connect(event_handler)
	$dialogue.Event.connect(event_handler)
	battle_loop()

func set_up(data: Dictionary):
	var enemies: Array = data["enemies"]
	for enemy_scene in enemies:
		add_enemy(enemy_scene)

func battle_loop():
	while true:
		for fighter: Character in turn_order:
			if interupt:
				await interupt_signal
				interupt = false
			if fighter.is_alive():
				fighter.start_turn(character_list)
				await fighter.End_turn
		calc_turn_order()
		
func check_win_condition():
	if num_fighters["Enemies"] <= 0:
		print("Heroes WIN!")
		#the level doesn't change fast enough, the loop will continue
		interupt = true
		interupt_signal = get_tree().create_timer(60).timeout
		change_level.emit("level_1", {"points":20}, false)
	elif num_fighters["Allies"] <= 0:
		print("Heros LOSE!")
		#the level doesn't change fast enough, the loop will continue
		interupt = true
		interupt_signal = get_tree().create_timer(60).timeout
		change_level.emit("level_1", {}, false)
		


func event_handler(character: Character, event_type: String, data: Dictionary):
	match event_type:
		#1) player turn
		"player_turn":
			$Combat.add_attacks(character.stats.get_attacks())
			$Combat.add_items(PlayerTeam.inventory.consumables)
			$Combat.display(event_type, {})
			current_char = character
			print("Player's turn")
		"select_target":
			selected_attack = data
			change_target(0)
				
			select_mode = true
			$Combat.visible = false
		"attack":
			var attack_targets = data["targets"]
			for target: Character in attack_targets:
				print("attacking: " + target.name)
				target.take_dmg(data["data"])
		"dead":
			print(character.name + " is dead!")
			var index = character_list["Enemies"].find(character)
			if index < 0:
				print("A Hero Died")
				index = character_list["Allies"].find(character)
				assert(index >= 0)
				character_list["Allies"].pop_at(index)
				num_fighters["Allies"] -= 1
			else:
				character_list["Enemies"].pop_at(index)
				num_fighters["Enemies"] -= 1
			index = turn_order.find(character)
			character.visible = false
			check_win_condition()
			retarget()
			for target in current_target["targets"]:
				target.show_selector(false)
#		"dialogue":
#			$Combat.display(event_type, data)
#			interupt_signal = $Combat.finished
#			interupt = true
		"start_dialogue", "dialogue":
			interupt_signal = $dialogue.finished
			interupt = true
			conv = data["conversation"]
			conv.set_speakers(character_list["Allies"], character_list["Enemies"], character.name)
			conv.build_conversation()
			var diag := conv.start_conversation()
			print(diag.dialogue)
			print(diag.get_responses())
			$dialogue.load_dialogue(diag)
		"next_dialogue":
			print("Did that work?")
			print("you chose: " + data["choice"])
			var diag = conv.get_next_option(data["choice"])
			#put effect here
			$dialogue.load_dialogue(diag)
		"end_dialogue":
			print("end dialogue")
			conv.end_conversation()
			conv = null
		_:
			print("ERROR, should not get here")
	#3) spawn helpers
	
func add_players():
	var player = load("res://characters/hero.tscn").instantiate()
	add_fighter(player, "player")
	var yellow = load("res://characters/hero.tscn").instantiate()
	yellow.name = "Yellow"
	add_fighter(yellow, "player")
	
func add_enemy(enemy_stat: String):
	var enemy = load("res://characters/red.tscn").instantiate()
	enemy.stat_block = enemy_stat
	add_fighter(enemy, "enemy")

func add_fighter(fighter:Character, team: String):
	match team:
		"player":
			var formation = get_node("fighters/Allies/player"+str(num_fighters["Allies"]))
			formation.add_child(fighter)
			character_list["Allies"].append(fighter)
			num_fighters["Allies"] += 1
		"enemy":
			var formation = get_node("fighters/Enemies/enemy"+str(num_fighters["Enemies"]))
			print("Adding enemy " + str(num_fighters["Enemies"]) + " to the scene at " + "fighters/enemy"+str(num_fighters["Enemies"]))
			formation.add_child(fighter)
			character_list["Enemies"].append(fighter)
			num_fighters["Enemies"] += 1
		_:
			print("Error adding new character!")
			return

func sort_characters(char1: Character, char2: Character):
	return char1.stats.SPD > char2.stats.SPD

func calc_turn_order():
	turn_order = []
	for ally: Character in character_list["Allies"]:
		turn_order.append(ally)
	for enemy: Character in character_list["Enemies"]:
		turn_order.append(enemy)
	turn_order.sort_custom(sort_characters)


func retarget():
	if current_target["targets"][0] in character_list[current_target["team"]]:
		var index = character_list[current_target["team"]].find(current_target["targets"][0])
		current_target["index"] = index
	elif len(character_list[current_target["team"]]) > 0:
		current_target["index"] = current_target["index"] % num_fighters[current_target["team"]]
		change_target(0)
		
func change_target(move_up:int = 1, new_fighter_team: String = ""):
		# disapear the indicator for the current targets	
		var figher_targets = current_target["targets"]
		for fighter in figher_targets:
			fighter.show_selector(false)
		# set the target team
		var fighter_team: String
		if new_fighter_team == "":
			fighter_team = current_target["team"]
		else:
			fighter_team = new_fighter_team
		
		# adjust the "base" index
		var fighter_index = current_target["index"]
		fighter_index = (fighter_index + move_up) % num_fighters[fighter_team]
		
		# select the new targets
		var new_targets = []
		var num_targets = selected_attack.get("num_targets", 1)
		if num_targets == Magic.target_type.ALL:
			num_targets = num_fighters[fighter_team]
		elif num_targets > num_fighters[fighter_team]:
			num_targets = num_fighters[fighter_team]
		for i in range(num_targets):
			var fighter = character_list[fighter_team][(fighter_index + i) % num_fighters[fighter_team]]
			fighter.show_selector(true)
			new_targets.append(fighter)
			
		current_target = {"index":fighter_index, "targets":new_targets, "team":fighter_team}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		if event.is_action_pressed("select_previous") and select_mode:
			change_target(-1)
		elif event.is_action_pressed("select_next") and select_mode:
			change_target(1)
		elif event.is_action_pressed("select_allies") and select_mode:
			change_target(0, "Allies")
		elif event.is_action_pressed("select_enemies") and select_mode:
			change_target(0, "Enemies")
		elif event.is_echo():
			print("Key press has echoed")
		elif event.is_action_pressed("ui_accept") and select_mode:
			for fighter_target in current_target["targets"]: 
				print("attacking: " + fighter_target.name)
			await current_char.attack(current_target["targets"], selected_attack)
			select_mode = false
			for target in current_target["targets"]:
				target.show_selector(false)
				