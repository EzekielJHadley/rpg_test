extends Character

static var instances: int = 0

var dialogue: Dictionary = {}

var stat_block : String

func _ready():
	instances += 1
	var new_stats = Stats.new()
	new_stats.load_from_json(stat_block)
	stats = new_stats
	name = stats.name+str(instances)
	texture = load(stats.SPRITE)
	hframes = stats.sprite_width
	vframes = stats.sprite_height
	offset.y = - texture.get_height()/(2 * vframes)
	scale = Vector2(-2,2)
	$Border.scale = Vector2(0.5, 0.5)
	$Border.offset.y = - texture.get_height()/(2 * vframes) + 64
	$Selector.position.x = - texture.get_width()/(2.0 * hframes)
	$Selector.position.y = - texture.get_height()/(3.0 * vframes)
	$Selector.scale = Vector2(0.5, 0.5)
	$StatusDisplay.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE )
	$StatusDisplay.position.y = 20
	#$StatusDisplay.set_size(Vector2(texture.get_width()/hframes, 20))
	

func _exit_tree() -> void:
	instances = max(instances - 1, 0)
	
func take_dmg(attk: Damage_info):
	super(attk)

func start_turn(character_list: Dictionary):
	await super(character_list)
	var target = character_list["Allies"][randi() % len(character_list["Allies"])]
	await attack([target], {"attack":"base_attack"})
	end_turn()
