
class_name SceneInfo

var health: int = 3
var next_scene: String

static func from_name(scene_name: String) -> SceneInfo:
	var info = SceneInfo.new()
	info.next_scene = scene_name
	return info
