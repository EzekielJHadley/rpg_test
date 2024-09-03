extends Character

static var instances: int = 0

var dialogue: Dictionary = {}

func _ready():
	instances += 1
	name = "Red"+str(instances)
	stats = Stats.new("res://characters/red.json")
	texture = load(stats.SPRITE)
	vulnerability.append(Globals.Dmg_type.ICE)
	resistant.append(Globals.Dmg_type.FIRE)

func _exit_tree() -> void:
	instances = max(instances - 1, 0)
	
func take_dmg(attk: Globals.Damage_info):
	super(attk)

func start_turn(character_list: Dictionary):
	await super(character_list)
	var target = character_list["Allies"][randi() % len(character_list["Allies"])]
	attack(target)
	end_turn()
