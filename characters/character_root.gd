extends Sprite2D
class_name Character

signal Event(character: Character, event_type: String, data: Dictionary)
signal End_turn

var stats: Stats:
	set(value):
		stats = value
		init_status_display()
		stats.health_update.connect(update_health_bar)
		stats.mana_update.connect(update_mana_bar)

func start_turn(_character_list: Dictionary):
	for effect in stats.passive_skills:
		await effect.on_turn_start(self)
	print("starting " + self.name + "'s turn!")

func end_turn():
	End_turn.emit()


func attack(target: Character):
	print(name + " is attacking")
	var atk_info: Globals.Damage_info = stats.base_attk()
	#play attack animation
	await play_attack_animation()
	var base_attk = {"target":target, "data":atk_info}
	Event.emit(self, "attack", base_attk)
	
func play_attack_animation():
	await get_tree().create_timer(1).timeout
	
func magic_attack(target: Character, spell: String):
	print(name + " is using: " + spell)
	#get spell scene, add to scene
	#await spell animation
	var atk_info = await stats.magic_attk(spell)
	var magic_attk = {"target":target, "data":atk_info}
	#attach spell scene and play animation
	await play_attack_animation() #using the animation stored in the magic atk_info
	Event.emit(self, "attack", magic_attk)

func play_magic_animation(animation = null):
	await get_tree().create_timer(1).timeout

func take_dmg(attk: Globals.Damage_info):	
	stats.defend(attk)
	
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

func init_status_display():
	$StatusDisplay/HealthBar.max_value = stats.HP_max
	$StatusDisplay/HealthBar.value = stats.HP
	if stats.MP_max > 0:
		$StatusDisplay/ManaBar.max_value = stats.MP_max
		$StatusDisplay/ManaBar.value = stats.MP
	else:
		$StatusDisplay/ManaBar.visible = false

func update_health_bar(new_hp):
	$StatusDisplay/HealthBar.value = new_hp

func update_mana_bar(new_mp):
	$StatusDisplay/ManaBar.value = new_mp
