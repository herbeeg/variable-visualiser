extends MarginContainer

var elapsed = 0
var timer_instance = null

func _ready():
	timer_instance = get_node('TimerLabel')
	timer_instance.text = '%02d' % elapsed

func _process(delta):
	elapsed += delta
	
	# floor() function call not required as the decimal format string automatically floors the integer.
	var minutes = elapsed / 60
	var seconds = int(elapsed)
	
	if 0 < int(minutes):
		# As the seconds are converted from a float to integer, they will continue to count up past
		# 60 so we want to manually reset that after each minute passes.
		seconds = seconds - (int(minutes) * 60)
	
	timer_instance.text = '%d:%02d' % [minutes, int(seconds)]
