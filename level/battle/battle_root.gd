extends Level_root

var current_char: Character = null
var current_target: Dictionary = {"index":0, "target":null, "team":"Enemies"}
var character_list: Dictionary = {"Allies":[], "Enemies":[]}
var turn_order: Array = []
var num_fighters: Dictionary = {"Allies":0, "Enemies":0}
var interupt: bool = false
var interupt_signal:Signal

func _ready() -> void:
	add_players()
	calc_turn_order()
	for fighter: Character in turn_order:
		fighter.Event.connect(event_handler)
	current_target["target"] = character_list["Enemies"][0]
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
			$Combat.add_spells(character.stats.get_spell_list())
			$Combat.add_items(PlayerTeam.inventory.consumables)
			$Combat.display(event_type, {})
			$Selector.visible = true
			current_char = character
			print("Player's turn")
		"attack":
			print("attacking: " + data["target"].name)
			data["target"].take_dmg(data["data"])
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
		"dialogue":
			$Combat.display(event_type, data)
			interupt_signal = $Combat.finished
			interupt = true
		_:
			print("ERROR, should not get here")
	#2) text interupts
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


func use_attack_action():
	$Selector.visible = false
	$Combat.visible = false
	await current_char.attack(current_target["target"])

func use_magic_attack(spell_name: String):
	$Selector.visible = false
	$Combat.visible = false
	await current_char.magic_attack(current_target["target"], spell_name)
	
func use_item(item: Consumable) -> void:
	$Selector.visible = false
	$Combat.visible = false
	await current_char.use_item(current_target["target"], item)

func retarget():
	if current_target["target"] in character_list[current_target["team"]]:
		var index = character_list[current_target["team"]].find(current_target["target"])
		current_target["index"] = index
	elif len(character_list[current_target["team"]]) > 0:
		current_target["index"] = current_target["index"] % num_fighters[current_target["team"]]
		current_target["target"] = character_list[current_target["team"]][current_target["index"]]
		$Selector.position = current_target["target"].global_position

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_pressed():
		var fighter_index = current_target["index"]
		var fighter_target = current_target["target"]
		var fighter_team = current_target["team"]
		if event.is_action_pressed("select_previous"):
			fighter_index = (fighter_index - 1) % num_fighters[fighter_team]
		elif event.is_action_pressed("select_next"):
			fighter_index = (fighter_index + 1) % num_fighters[fighter_team]
		elif event.is_action_pressed("select_allies"):
			$Selector.scale.x = -1
			fighter_team = "Allies"
			fighter_index = fighter_index % num_fighters[fighter_team]
		elif event.is_action_pressed("select_enemies"):
			$Selector.scale.x = 1
			fighter_team = "Enemies"
			fighter_index = fighter_index % num_fighters[fighter_team]
		
		fighter_target = character_list[fighter_team][fighter_index]
		$Selector.position = fighter_target.global_position
		current_target = {"index":fighter_index, "target":fighter_target, "team":fighter_team}
		print("New target: " + str(current_target))
