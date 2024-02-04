class_name Ui extends CanvasLayer

signal game_started
var player_won_text: String

@onready var end_of_game_screen = $end_of_game_screen
@onready var won_label = $end_of_game_screen/end_game_score/player_won_label

func _ready() -> void:
	pass

func update_player_won() -> void:
	won_label.text = "Spieler x hat gewonnen!"

func on_game_over() -> void:
	end_of_game_screen.visible = true

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
