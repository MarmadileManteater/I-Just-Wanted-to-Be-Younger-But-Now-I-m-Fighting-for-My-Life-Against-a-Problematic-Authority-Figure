
class_name SceneInfo

var health: int = 3
var next_scene: String
var is_checkpoint: bool = false

static func from_name(scene_name: String) -> SceneInfo:
	var info = SceneInfo.new()
	info.next_scene = scene_name
	return info

static func checkpoint(check_point_data: CheckPointData) -> SceneInfo:
	var info = from_name(check_point_data.scene_name)
	info.health = check_point_data.health
	info.is_checkpoint = true
	return info
