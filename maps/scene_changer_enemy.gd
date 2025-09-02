@tool
extends SceneChanger


@export var enemies: Array[EnemyGen.types]:
	set(value):
		enemies = value
		if len(enemies) > 0:
			var first_enemy_stats = EnemyGen.generate(enemies[0])
			var first_enemy = FileManager.load_json(first_enemy_stats)
			$map_sprite.texture = load(first_enemy["MAP_SPRITE"])
			$map_sprite.hframes = first_enemy["sprite_width"]
			$map_sprite.vframes = first_enemy["sprite_height"]
			$Area2D/CollisionShape2D.shape.set_size($map_sprite.get_rect().size)
			
var global_name: String

func _ready():
	if not Engine.is_editor_hint():
		init_name()
		var current_state = GameFlags.get_flag(global_name)
		disable(current_state)
		
		data["map_sprite"] = name
		if level_name == "":
			level_name = "level/battle/grass_level_battle"
		if not data.has("enemies"):
			data["enemies"] = []
		for enemy in enemies:
			data["enemies"].append(EnemyGen.generate(enemy))
		if not data.has("next_scene"):
			data["next_scene"] = owner.scene_file_path.replace("res://", "").replace(".tscn", "")
		super()

		
func init_name():
	var path: String = owner.scene_file_path  
	var uid: int = ResourceLoader.get_resource_uid(path)
	var uid_string := ResourceUID.id_to_text(uid).replace("uid://", "")
	print("Chest {%s} is owned by %s" % [name, uid_string])
	global_name = "%s:%s" % [uid_string, name]

func dead():
	init_name()
	GameFlags.set_flag(global_name)

func disable(toggle:bool = true):
	$Area2D/CollisionShape2D.set_deferred("disabled", toggle)
	visible = not toggle