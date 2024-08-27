extends Sprite2D
class_name Character

signal Event(character: Character, event_type: String, data: Dictionary)
signal End_turn

var stats: Stats:
	set(value):
		stats = value
		init_health_bar()

func start_turn(_character_list: Dictionary):
	print("starting " + self.name + "'s turn!")

func end_turn():
	await get_tree().create_timer(1).timeout
	End_turn.emit()


func attack(target):
	print(name + " is attacking")
	var atk_info = stats.base_attk()
	var base_attk = {"target":target, "data":atk_info}
	Event.emit(self, "attack", base_attk)
	
func take_dmg(attk: Dictionary):
	stats.HP -= attk["dmg"]
	update_health_bar()
	if stats.HP <= 0:
		Event.emit(self, "dead", {})
		
func character_dead():
	queue_free()

func is_alive() -> bool:
	return stats.HP > 0

func init_health_bar():
	$HealthBar.max_value = stats.HP_max
	$HealthBar.value = stats.HP

func update_health_bar():
	$HealthBar.value = stats.HP
