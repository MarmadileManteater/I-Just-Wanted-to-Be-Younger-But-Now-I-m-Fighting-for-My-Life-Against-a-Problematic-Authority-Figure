
class_name TrackInfo

var name: String
var loop: bool = true

static func from(track_name: String, looping: bool = true) -> TrackInfo:
	var info = TrackInfo.new()
	info.name = track_name
	info.loop = looping
	return info
