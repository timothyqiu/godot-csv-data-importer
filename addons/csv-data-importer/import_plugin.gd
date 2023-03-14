tool
extends EditorImportPlugin

enum Presets { CSV, CSV_HEADER, TSV, TSV_HEADER }
enum Delimiters { COMMA, TAB }


func get_importer_name():
	return "com.timothyqiu.godot-csv-importer"


func get_visible_name():
	return "CSV Data"


func get_priority():
	# The built-in Translation importer needs a restart to switch to other importer
	return 2.0


func get_recognized_extensions():
	return ["csv", "tsv"]


func get_save_extension():
	return "res"


func get_resource_type():
	return "Resource"


func get_preset_count():
	return Presets.size()


func get_preset_name(preset):
	match preset:
		Presets.CSV:
			return "CSV"
		Presets.CSV_HEADER:
			return "CSV with headers"
		Presets.TSV:
			return "TSV"
		Presets.TSV_HEADER:
			return "TSV with headers"
		_:
			return "Unknown"


func get_import_options(preset):
	var delimiter = Delimiters.COMMA
	var headers = false
	match preset:
		Presets.CSV_HEADER:
			headers = true
		Presets.TSV:
			delimiter = Delimiters.TAB
		Presets.TSV_HEADER:
			delimiter = Delimiters.TAB
			headers = true
	
	return [
		{name="delimiter", default_value=delimiter, property_hint=PROPERTY_HINT_ENUM, hint_string="Comma,Tab"},
		{name="headers", default_value=headers},
		{name="detect_numbers", default_value=false},
		{name="force_float", default_value=true},
	]


func get_option_visibility(option, options):
	return true  # Godot does not update the visibility immediately
	if option == "force_float":
		return options.detect_numbers
	return true


func import(source_file, save_path, options, platform_variants, gen_files):
	var delim: String
	match options.delimiter:
		Delimiters.COMMA:
			delim = ","
		Delimiters.TAB:
			delim = "\t"
	
	var file := File.new()
	var err := file.open(source_file, File.READ)
	if err != OK:
		printerr("Failed to open file: ", err)
		return FAILED
	
	var lines = []
	while not file.eof_reached():
		var line = file.get_csv_line(delim)
		if options.detect_numbers and (not options.headers or lines.size() > 0):
			var detected := []
			for field in line:
				if not options.force_float and field.is_valid_integer():
					detected.append(int(field))
				elif field.is_valid_float():
					detected.append(float(field))
				else:
					detected.append(field)
			lines.append(detected)
		else:
			lines.append(line)
	file.close()
	
	# Remove trailing empty line
	if not lines.empty() and lines.back().size() == 1 and lines.back()[0] == "":
		lines.pop_back()

	var data = preload("csv_data.gd").new()
	
	if options.headers:
		if lines.empty():
			printerr("Can't find header in empty file")
			return ERR_PARSE_ERROR
		
		var headers = lines[0]
		for i in range(1, lines.size()):
			var fields = lines[i]
			if fields.size() > headers.size():
				printerr("Line %d has more fields than headers" % i)
				return ERR_PARSE_ERROR
			var dict = {}
			for j in headers.size():
				var name = headers[j]
				var value = fields[j] if j < fields.size() else null
				dict[name] = value
			data.records.append(dict)
	else:
		data.records = lines
	
	var filename = save_path + "." + get_save_extension()
	err = ResourceSaver.save(filename, data)
	if err != OK:
		printerr("Failed to save resource: ", err)
	return err
