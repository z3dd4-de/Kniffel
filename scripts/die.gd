extends Node2D
class_name Die 

var value: int
var running = false
var kept = false
var selected = false
var start_position

@export var id: int


func _ready() -> void:
	randomize()
	running = true
	selected = false
	$Timer.start()
	start_position = position


func _process(delta) -> void:
	if running:
		roll()


func start_rolling():
	running = true
	$Timer.start()


func roll() -> void:
	if running:
		value = randi_range(1,6)
		rotate(randf())
		match value:
			1:
				$AnimatedSprite2D.play("1")
			2:
				$AnimatedSprite2D.play("2")
			3:
				$AnimatedSprite2D.play("3")
			4:
				$AnimatedSprite2D.play("4")
			5:
				$AnimatedSprite2D.play("5")
			6:
				$AnimatedSprite2D.play("6")


func _physics_process(delta) -> void:
	if selected and Globals.current_die == self:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)


func _on_timer_timeout() -> void:
	#print("ID " + str(id) + " " + str(value))
	#print(start_position)
	rotation = 0
	running = false


func _input(event) -> void:
	if event is InputEventMouseButton and Globals.current_die == self:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false
			Globals.current_die = null


func _on_area_2d_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		Globals.current_die = self
		selected = true

