# Godot CSV Data Importer

<img src="icon.png?raw=true"  align="right" />

[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![中文 README](https://img.shields.io/badge/README-%E4%B8%AD%E6%96%87-red)](README-zh_CN.md)

Import CSV/TSV files as native Array or Dictionaries.

To install, download the ZIP archive, extract it, and move the `addons/` folder it
contains into your project folder. Then, enable the plugin in project settings.

To use this importer, select the CSV/TSV file, change Import As to "CSV Data" in
the Import dock, set the import options and click Reimport.

The CSV/TSV file will be imported as a custom `Resource` object. Lines in the
file will be turned into elements of an array named `records` on the object.

```gdscript
func _ready():
	var data = preload("res://example.csv")
	print(data.records)  # array of data
```

The type of array elements is determined by the import options. `records` is
an array of string arrays by default.

## Import Options

* **Delimiter**
	*	Use "Comma" for CSV and "Tab" for TSV.
* **Headers**
	*	Use the first line as header fields.
		Each element of `records` will be a `Dictionary` with header fields as keys.
* **Detect Numbers**
	* Convert fields from string to `int` or `float` when possible.
* **Force Float**
	* Always use `float` when detecting numbers.

## Example

After importing `res://example.csv`:

```csv
Apple,Banana,Cherry,Durian
-12,13,14.0,20.5
```

The value of `preload("res://example.csv").records` will be:

```gdscript
# By default
[
	["Apple", "Banana", "Cherry", "Durian"],
	["-12", "13", "14.0", "20.5"],
]

# With "Headers" enabled
[
	{
		"Apple": "-12",
		"Banana": "13",
		"Cherry": "14.0",
		"Durian": "20.5",
	},
]

# With "Detect Numbers" and "Force Float" enabled
[
	["Apple", "Banana", "Cherry", "Durian"],
	[-12.0, 13.0, 14.0, 20.5],

# With "Detect Numbers" enabled and "Force Float" disabled
[
	["Apple", "Banana", "Cherry", "Durian"],
	[
		-12,   # int
		13,    # int
		14.0,  # float
		20.5,  # float
	],
]
```
