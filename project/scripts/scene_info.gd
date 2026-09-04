
class_name SceneInfo

var health: int = 3
var next_scene: String
var is_checkpoint: bool = false
var checkpoint_flags: Array = []

static func from_name(scene_name: String) -> SceneInfo:
	var info = SceneInfo.new()
	info.next_scene = scene_name
	return info

static func from_hearts(health: int, is_checkpoint: bool = true) -> SceneInfo:
	var info = SceneInfo.new()
	info.health = health
	info.is_checkpoint = is_checkpoint
	return info

static func checkpoint(health: int, flags: Array = []) -> SceneInfo:
	var info = SceneInfo.new()
	info.health = health
	info.is_checkpoint = true
	info.checkpoint_flags = flags
	return info
