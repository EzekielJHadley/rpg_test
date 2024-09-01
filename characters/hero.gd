extends Character

func _ready():
	stats = Stats.new(name, 10, 2, 3, "res://icon.svg")
	stats.add_spell(Ice_spell.new())
	stats.add_spell(Fire_spell.new())

func start_turn(_character_list: Dictionary):
	await super(_character_list)
	Event.emit(self, "player_turn", {})
	
func attack(target):
	super(target)
	end_turn()

func magic_attack(target: Character, spell: String):
	super(target, spell)
	end_turn()

func character_dead():
	scale.y = -1
