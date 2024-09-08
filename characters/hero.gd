extends Character

func _ready():
	stats = PlayerTeam.team[name]

func start_turn(character_list: Dictionary):
	await super(character_list)
	Event.emit(self, "player_turn", {})
	
func attack(target):
	await super(target)
	end_turn()

func magic_attack(target: Character, spell: String):
	super(target, spell)
	end_turn()

func character_dead():
	scale.y = -1
