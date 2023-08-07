extends MarginContainer

var elapsed = 0.0
var timer_instance = null

func _ready():
	timer_instance = get_node('TimerLabel')
	timer_instance.text = '%3.2f' % elapsed

func _process(delta):
	elapsed += delta
	timer_instance.text = '%3.2f' % elapsed
