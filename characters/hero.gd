extends Character

func _ready():
	stats = Stats.new(10, 2)

func start_turn(_character_list: Dictionary):
	await super(_character_list)
	Event.emit(self, "player_turn", {})
	
func attack(target):
	super(target)
	end_turn()

func character_dead():
	scale.y = -1
