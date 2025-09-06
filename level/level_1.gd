extends Level_root

var score: int = 0:
	set(value):
		score = value
		$VBoxContainer/a_number.text = str(score)
		
func _ready():
	score = 0
	$battle.grab_focus()
	
	if not FileAccess.file_exists("user://savegame.save"):
		$load.disabled = true
	

func set_up(data: Dictionary):
	var bonus_points = data.get("points", 0)
	score += bonus_points

func increment_button():
	score += 1

func _on_load_pressed():
	print("Loading from file!")
	var save_data = FileManager.load_data()
	print("Changing to scene " + save_data["map"])
	change_scene(save_data["map"], save_data["data"], false)