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


func attack(target: Character):
	print(name + " is attacking")
	var atk_info: Globals.Damage_info = stats.base_attk()
	var base_attk = {"target":target, "data":atk_info}
	Event.emit(self, "attack", base_attk)
	
func magic_attack(target: Character, spell: String):
	print(name + " is using: " + spell)
	#get spell scene, add to scene
	#await spell animation
	var atk_info = stats.magic_attk(spell)
	var magic_attk = {"target":target, "data":atk_info}
	Event.emit(self, "attack", magic_attk)
	
func take_dmg(attk: Globals.Damage_info):
	var dmg_taken = attk.damage
	if attk.dmg_type in stats.vulnerability:
		dmg_taken *= 2
	elif attk.dmg_type in stats.resistant:
		dmg_taken = floor(dmg_taken/2.0)
	elif attk.dmg_type in stats.immune or attk.dmg_type == Globals.Dmg_type.NONE:
		dmg_taken = 0
	stats.HP -= dmg_taken
	update_health_bar()
	
	if stats.HP <= 0:
		Event.emit(self, "dead", {})
		return
	
	for inter: Interupt in $interupts.get_children():
		if inter.is_triggered(stats):
			print("triggered interupt: " + inter.name)
			var inter_type = inter.interupt_type()
			var inter_data = inter.interupt_data()
			Event.emit(self, inter_type, inter_data)
		
func character_dead():
	queue_free()

func is_alive() -> bool:
	return stats.HP > 0

func init_health_bar():
	$HealthBar.max_value = stats.HP_max
	$HealthBar.value = stats.HP

func update_health_bar():
	$HealthBar.value = stats.HP
