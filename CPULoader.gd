extends Spatial


var threads = int(OS.get_processor_count())
var workforce = []
var keep_running = true
var stress_cpu = true
var target = 60
var warmup = true
var fps = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	print(threads)
	if stress_cpu:
		for i in range(threads):
			var newthread = Thread.new()
			#newthread.start(self, "pointless_job", null, Thread.PRIORITY_LOW)
			workforce.append(newthread)

func _exit_tree():
	keep_running = false

func pointless_job(data):
	while keep_running:
		var numb = 1.0
		for i in range(1000):
			numb *= (randf() + 0.55)

var desiredres = 32.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var fps = Performance.get_monitor(Performance.TIME_FPS)
	if not warmup:
		if fps > target:
			desiredres += 20*delta
		else:
			desiredres -= 20*delta
		if desiredres > 32.0:
			#$Viewport/PlanarReflector.resolution = desiredres
			#$Viewport/PlanarReflector2.resolution = desiredres
			#$Viewport/PlanarReflector3.resolution = desiredres
			$Viewport.size.x = desiredres
			$Viewport.size.y = desiredres
		var respercent = int(($Viewport.size.x / 512)*100)
		$Label.text = "Resolution: " + str(respercent) + "%"
	$Label2.text = "FPS: " + str(fps)


func _on_Timer_timeout():
	$ColorRect2.queue_free()
	warmup = false
	for th in workforce:
		th.start(self, "pointless_job", null, 0)
