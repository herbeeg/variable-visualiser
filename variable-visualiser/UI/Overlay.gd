extends MarginContainer

var elapsed = 0
var full_length = ''
var timer_instance = null

func _ready():
	timer_instance = get_node('TimerLabel')
	timer_instance.text = '%02d' % elapsed
	
	full_length = self.convertSongLength(GlobalSettings.overlay['duration'])

func _process(delta):
	if GlobalSettings.overlay['duration'] > int(elapsed):
		elapsed += delta
		
		# floor() function call not required as the decimal format string automatically floors the integer.
		var minutes = elapsed / 60
		var seconds = int(elapsed)
		
		if 0 < int(minutes):
			# As the seconds are converted from a float to integer, they will continue to count up past
			# 60 so we want to manually reset that after each minute passes.
			seconds = seconds - (int(minutes) * 60)
		
		timer_instance.text = '%d:%02d // %s' % [minutes, int(seconds), full_length]
	
func convertSongLength(duration : int) -> String:
	var converted = ''
	if 60 > duration:
		# Skip conversions if we know that the minutes will be 0.
		converted = '0:%d' % duration
	else:
		var minutes = int(duration / 60)
		var seconds = duration - (minutes * 60)
		converted = '%d:%d' % [minutes, seconds]
	
	return converted
