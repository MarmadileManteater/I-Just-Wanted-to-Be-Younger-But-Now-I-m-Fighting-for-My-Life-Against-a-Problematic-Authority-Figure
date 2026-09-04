
class_name CheckPointData

var health: int = 3
var scene_name: String = ""
var flags: Array = []

static func from(name: String, health: int = 3) -> CheckPointData:
	var data = CheckPointData.new()
	data.scene_name = name
	data.health = health
	return data

static func from_health(health: int) -> CheckPointData:
	var data = CheckPointData.new()
	data.health = health
	return data
