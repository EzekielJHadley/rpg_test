extends RefCounted
class_name FileManager


static func load_json(input_file: String) -> Dictionary:
	var json = JSON.new()
	print(FileAccess.file_exists(input_file))
	var json_text = FileAccess.open(input_file, FileAccess.READ).get_as_text()
	var error = json.parse(json_text)
	assert(error == OK)
	return json.data

