extends Level_root

var score: int = 0:
	set(value):
		score = value
		$VBoxContainer/a_number.text = str(score)
		
func _ready():
	score = 0
	$battle.grab_focus()
	

func set_up(data: Dictionary):
	var bonus_points = data.get("points", 0)
	score += bonus_points

func increment_button():
	score += 1
