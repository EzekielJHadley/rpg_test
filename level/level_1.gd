extends Level_root

var score: int = 0:
	set(value):
		score = value
		$VBoxContainer/a_number.text = str(score)
		
func _ready():
	score = 0
	$battle.grab_focus()
	
	var test = {"one":1, "two":"2", "three":3}
	print(var_to_str(test))
#	print(Marshalls.variant_to_base64(test, true))
#	print(var_to_bytes_with_objects(test))
#	var test1 = Damage_info.new(Damage_info.Dmg_type.FIRE, 2, [])
#	print(test1._get_property_list())
#	var file = FileAccess.open("res://test1.txt", FileAccess.READ_WRITE)
#	file.store_var(test1, true)
#	var test1 = file.get_var(true)
#	var test1 = str_to_var("Object(RefCounted,\"script\":Resource(\"res://helpers/damage_info.gd\"),\"element\":2,\"damage\":2,\"status_effects\":[])")
#	print(test1.element)
#	print(var_to_str(test1))
#	print(Marshalls.variant_to_base64(test1, true))
#	var test1 = Marshalls.base64_to_variant("GwAAAAMAAAAEAAAAAwAAAG9uZQACAAAAAQAAAAQAAAADAAAAdHdvAAQAAAABAAAAMgAAAAQAAAAFAAAAdGhyZWUAAAACAAAAAwAAAA==", true)
#	print(test1)
#	print(test == test1)


	

func set_up(data: Dictionary):
	var bonus_points = data.get("points", 0)
	score += bonus_points

func increment_button():
	score += 1
