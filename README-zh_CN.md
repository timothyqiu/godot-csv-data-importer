# Godot CSV 数据导入器

<img src="icon.png?raw=true"  align="right" />

[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![English README](https://img.shields.io/badge/README-English-red)](README.md)

将 CSV/TSV 文件导入为原生数组或字典。

安装方法：下载 ZIP 包，解压后将 `addons/` 文件夹移动到你的项目文件夹中，然后在项目设置中启用本插件。

使用方法：选中 CSV/TSV 文件，在「导入」面板中将「导入为」设置为「CSV Data」，设置好导入选项后点击「重新导入」。

CSV/TSV 文件会被导入为自定义的 `Resource` 对象。这个资源对象有一个叫做 `records` 的数组字段，其中的每个元素对应数据文件中的一行。

```gdscript
func _ready():
	var data = preload("res://example.csv")
	print(data.records)  # 数据的数组
```

数组元素的类型受导入选项的影响。默认情况下，`records` 是一个字符串数组的数组。

## 导入选项

* **Delimiter**
	*	分隔符：CSV 文件选「Comma」，TSV 文件选「Tab」。
* **Headers**
	*	标题：将第一行用作标题字段。`records` 中的每个元素都会变成字典 `Dictionary`，字典中包含所有的标题字段。
* **Detect Numbers**
	* 检测数字：尽可能将原本的字符串值转换为 `int` 或 `float`。
* **Force Float**
	* 强制浮点类型：检测数字时始终使用 `float`。

## 示例

如果导入的是如下 `res://example.csv` 文件：

```csv
Apple,Banana,Cherry,Durian
-12,13,14.0,20.5
```

那么 `preload("res://example.csv").records` 的值就是：

```gdscript
# 默认情况
[
	["Apple", "Banana", "Cherry", "Durian"],
	["-12", "13", "14.0", "20.5"],
]

# 启用 Headers
[
	{
		"Apple": "-12",
		"Banana": "13",
		"Cherry": "14.0",
		"Durian": "20.5",
	},
]

# 启用 Detect Numbers 和 Force Float
[
	["Apple", "Banana", "Cherry", "Durian"],
	[-12.0, 13.0, 14.0, 20.5],

# 启用 Detect Numbers 禁用 Force Float
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
