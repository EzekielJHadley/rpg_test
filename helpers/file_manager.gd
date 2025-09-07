extends RefCounted
class_name FileManager

static var save_file_name: String = "user://savegame.save"

static func load_json(input_file: String) -> Dictionary:
	var json = JSON.new()
	print(FileAccess.file_exists(input_file))
	var json_text = FileAccess.open(input_file, FileAccess.READ).get_as_text()
	var error = json.parse(json_text)
	assert(error == OK)
	return json.data

static func save_dict(file_name: String, data: Dictionary):
	var save_file = FileAccess.open(file_name, FileAccess.WRITE)
	var json_text = JSON.stringify(data, "\t")
	save_file.store_string(json_text)

static func save_game(level_name: String, level_data: Dictionary):
	var save_state = {}
	save_state["map"] = level_name
	save_state["data"] = level_data
	save_state["team"] = PlayerTeam.export_team()
	save_state["flags"] = GameFlags.export_flags()
	
	FileManager.save_dict(FileManager.save_file_name, save_state)
	print("Game Saved!!!")
	
static func load_data():
	var save_data = FileManager.load_json(FileManager.save_file_name)
	GameFlags.import_flags(save_data.get("flags", {}))
	PlayerTeam.import_team(save_data["team"]["team"], save_data["team"]["inventory"])
	return save_data