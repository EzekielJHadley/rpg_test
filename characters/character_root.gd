extends Sprite2D
class_name Character

signal Event(character: Character, event_type: String, data: Dictionary)
signal End_turn

var PORTRAIT: String
var stats: Stats:
	set(value):
		stats = value
		PORTRAIT = stats.PORTRAIT
		init_status_display()
		stats.health_update.connect(update_health_bar)
		stats.mana_update.connect(update_mana_bar)

func _ready():
	#set up sprite
	texture = load(stats.SPRITE)
	hframes = stats.sprite_width
	vframes = stats.sprite_height
	offset.y = - texture.get_height()/(2.0 * vframes)
	#set up Selector
	$Selector.position.x = - texture.get_width()/(2.0 * hframes)
	$Selector.position.y = - texture.get_height()/(3.0 * vframes)
	#set up status display
	$StatusDisplay.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE )
	$StatusDisplay.position.y = 20


func start_turn(_character_list: Dictionary):
	for effect in stats.modifiers.get_mods():
		await effect.on_turn_start(self)
  
	$Border.visible = true
	print("starting " + self.name + "'s turn!")

func end_turn():
	$Border.visible = false
	End_turn.emit()


func attack(targets: Array, attack_type: Dictionary):
	print(name + " is attacking")
	var atk_info: Damage_info
	var attk: Dictionary
	match attack_type["attack"]:
		"base_attack":
			atk_info = stats.base_attk()
			#play attack animation
			await play_attack_animation()
			attk = {"targets":targets, "data":atk_info}
		"magic_attack":
			atk_info =  stats.magic_attk(attack_type["name"])
			attk = {"targets":targets, "data":atk_info}
			await play_attack_animation() #using the animation stored in the magic atk_info
		"use_item":
			var item = attack_type["attk_info"]
			print(name + " is using " + item.name + " on " + targets[0].name)
			var item_info = PlayerTeam.inventory.use_item(item)
			attk = {"targets":targets, "data":item_info}
			await play_attack_animation() #using the animation stored in the item
	Event.emit(self, "attack", attk)
		
	
func play_attack_animation():
	await get_tree().create_timer(1).timeout
	
#func magic_attack(target: Character, spell: String):
#	print(name + " is using: " + spell)
#	#get spell scene, add to scene
#	#await spell animation
#	var atk_info = stats.magic_attk(spell)
#	var magic_attk = {"target":target, "data":atk_info}
#	#attach spell scene and play animation
#	await play_attack_animation() #using the animation stored in the magic atk_info
#	Event.emit(self, "attack", magic_attk)
#	
#func use_item(target: Character, item: Consumable):
#	print(name + " is using " + item.name + " on " + target.name)
#	var item_info = PlayerTeam.inventory.use_item(item)
#	var item_attack = {"target":target, "data":item_info}
#	await play_attack_animation()
#	Event.emit(self, "attack", item_attack)

func play_magic_animation(_animation = null):
	await get_tree().create_timer(1).timeout

func take_dmg(attk: Damage_info):	
	stats.defend(attk)
	for effect in attk.status_effects:
		apply_effect(effect)

	
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
	
func show_selector(selector_state: bool = true) -> void:
	$Selector.visible = selector_state

func apply_effect(effect: Effect):
	effect.instant(self)
	if effect.effect_type != "instant":
		#attach scene here
		$StatusDisplay/status_effects.add_child(effect.get_icon())
		#send effect to stats
		stats.modifiers.add_mod(effect)

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
