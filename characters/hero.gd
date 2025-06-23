extends Character

func _ready():
	stats = PlayerTeam.team[name]
	super()
	frame = 2

func start_turn(character_list: Dictionary):
	await super(character_list)
	Event.emit(self, "player_turn", {})
	
func attack(targets: Array, attack_type: Dictionary):
	await super(targets, attack_type)
	end_turn()

#func magic_attack(target: Character, spell: String):
#	await super(target, spell)
#	end_turn()
#
#func use_item(target: Character, item: Consumable):
#	await super(target, item)
#	end_turn()

func character_dead():
	scale.y = -1
