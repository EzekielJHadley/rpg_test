extends Character

func _ready():
	stats = Stats.new(name, 10, 2, "res://icon.svg")

func start_turn(_character_list: Dictionary):
	await super(_character_list)
	Event.emit(self, "player_turn", {})
	
func attack(target):
	super(target)
	end_turn()

func character_dead():
	scale.y = -1
