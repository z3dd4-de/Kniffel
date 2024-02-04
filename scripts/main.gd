class_name Game extends Node2D

@export var show_sums:bool = true 
@onready var sums_container = %SumsContainer

var keep_ids: Array[int]
var players: Array[Player]
var player_count: int
var current_player: int
var player_round: int
var game_round: int

#Buttons
@onready var _1_er_button = $"GamePanel/GridContainer/1erButton"
@onready var _2_er_button = $"GamePanel/GridContainer/2erButton"
@onready var _3_er_button = $"GamePanel/GridContainer/3erButton"
@onready var _4_er_button = $"GamePanel/GridContainer/4erButton"
@onready var _5_er_button = $"GamePanel/GridContainer/5erButton"
@onready var _6_er_button = $"GamePanel/GridContainer/6erButton"
@onready var _3_er_pasch_button = $"GamePanel/GridContainer/3erPaschButton"
@onready var _4_er_pasch_button = $"GamePanel/GridContainer/4erPaschButton"
@onready var kl_str_button = $GamePanel/GridContainer/KlStrButton
@onready var gr_str_button = $GamePanel/GridContainer/GrStrButton
@onready var fh_button = $GamePanel/GridContainer/FHButton
@onready var kniffel_button = $GamePanel/GridContainer/KniffelButton
@onready var chance_button = $GamePanel/GridContainer/ChanceButton
#Values
@onready var _1_er_value = $"GamePanel/GridContainer/1erValue"
@onready var _2_er_value = $"GamePanel/GridContainer/2erValue"
@onready var _3_er_value = $"GamePanel/GridContainer/3erValue"
@onready var _4_er_value = $"GamePanel/GridContainer/4erValue"
@onready var _5_er_value = $"GamePanel/GridContainer/5erValue"
@onready var _6_er_value = $"GamePanel/GridContainer/6erValue"
@onready var _3_er_pasch_value = $"GamePanel/GridContainer/3erPaschValue"
@onready var _4_er_pasch_value = $"GamePanel/GridContainer/4erPaschValue"
@onready var kl_str_value = $GamePanel/GridContainer/KlStrValue
@onready var gr_str_value = $GamePanel/GridContainer/GrStrValue
@onready var fh_value = $GamePanel/GridContainer/FHValue
@onready var kniffel_value = $GamePanel/GridContainer/KniffelValue
@onready var chance_value = $GamePanel/GridContainer/ChanceValue
#Dice
@onready var die_0 = $die0
@onready var die_1 = $die1
@onready var die_2 = $die2
@onready var die_3 = $die3
@onready var die_4 = $die4

@onready var player_label = $GamePanel/PlayerLabel

var dice: Array[Die]
var values: Array[int]
var dice_counts: Array[int]

var sum_top: int = 0
var sum_bottom: int = 0
var bonus: int = 0
var total_sum: int = 0
var sum_all_dice: int = 0


func _ready() -> void:
	Globals.current_die = null
	

func _start_game():
	_reset_values()
	dice.append(die_0)
	dice.append(die_1)
	dice.append(die_2)
	dice.append(die_3)
	dice.append(die_4)
	player_round = 1
	game_round = 1
	#_calc_sum_top()
	_update_player_label()
	_roll_dice()
	$Timer.start()


func _update_player_label() -> void:
	player_label.text = players[current_player].player_name + ": " + str(game_round) + "-"+ str(player_round)


func _next_round() -> void:
	_save_player()
	print("Next Round: " + str(player_count))
	$CanvasLayer/NextRoundPanel.visible = true
	if players.size() == 1:
		$CanvasLayer/NextRoundPanel/NextRoundButton.text = "Nächste Runde"
	else:
		$CanvasLayer/NextRoundPanel/NextRoundButton.text = "Nächster Spieler"
		current_player += 1
		if current_player == player_count:
			current_player = 0


#func  _next_player() -> void:
#	_save_player()


func _reset_values() -> void:
	_1_er_value.text = ""
	_2_er_value.text = ""
	_3_er_value.text = ""
	_4_er_value.text = ""
	_5_er_value.text = ""
	_6_er_value.text = ""
	_3_er_pasch_value.text = ""
	_4_er_pasch_value.text = ""
	kl_str_value.text = ""
	gr_str_value.text = ""
	fh_value.text = ""
	kniffel_value.text = ""
	chance_value.text = ""
	_disable_all()
	$GamePanel/SumsContainer/BonusValue.text = "0"


func _disable_all() -> void:
	_1_er_button.disabled = true
	_2_er_button.disabled = true
	_3_er_button.disabled = true
	_4_er_button.disabled = true
	_5_er_button.disabled = true
	_6_er_button.disabled = true
	_3_er_pasch_button.disabled = true
	_4_er_pasch_button.disabled = true
	kl_str_button.disabled = true
	gr_str_button.disabled = true
	fh_button.disabled = true
	kniffel_button.disabled = true
	chance_button.disabled = true
	_calc_sums()


func _calc_sums() -> void:
	_calc_sum_top()
	_calc_sum_bottom()
	total_sum = sum_top + bonus + sum_bottom
	$GamePanel/SumsContainer/TotalSumValue.text = str(total_sum)


func _calc_sum_top() -> void:
	sum_top = 0
	if _1_er_value.text != "":
		sum_top += int(_1_er_value.text)
	if _2_er_value.text != "":
		sum_top += int(_2_er_value.text)
	if _3_er_value.text != "":
		sum_top += int(_3_er_value.text)
	if _4_er_value.text != "":
		sum_top += int(_4_er_value.text)
	if _5_er_value.text != "":
		sum_top += int(_5_er_value.text)
	if _6_er_value.text != "":
		sum_top += int(_6_er_value.text)
	$GamePanel/SumsContainer/TopSumValue.text = str(sum_top)
	if sum_top >= 63:
		$GamePanel/SumsContainer/BonusValue.text = "+35"
		bonus = 35
	else:
		$GamePanel/SumsContainer/BonusValue.text = "0"
		bonus = 0


func _calc_sum_bottom() -> void:
	sum_bottom = 0
	if _3_er_pasch_value.text != "":
		sum_bottom += int(_3_er_pasch_value.text)
	if _4_er_pasch_value.text != "":
		sum_bottom += int(_4_er_pasch_value.text)
	if kl_str_value.text != "":
		sum_bottom += int(kl_str_value.text)
	if gr_str_value.text != "":
		sum_bottom += int(gr_str_value.text)
	if fh_value.text != "":
		sum_bottom += int(fh_value.text)
	if kniffel_value.text != "":
		sum_bottom += int(kniffel_value.text)
	if chance_value.text != "":
		sum_bottom += int(chance_value.text)
	$GamePanel/SumsContainer/BottomSumValue.text = str(sum_bottom)


func _check_values() -> void:
	values.clear()
	sum_all_dice = 0
	for die in dice:
		values.append(die.value)
		if die.value == 1 and _1_er_value.text == "":
			_1_er_button.disabled = false
		if die.value == 2 and _2_er_value.text == "":
			_2_er_button.disabled = false
		if die.value == 3 and _3_er_value.text == "":
			_3_er_button.disabled = false
		if die.value == 4 and _4_er_value.text == "":
			_4_er_button.disabled = false
		if die.value == 5 and _5_er_value.text == "":
			_5_er_button.disabled = false
		if die.value == 6 and _6_er_value.text == "":
			_6_er_button.disabled = false
		sum_all_dice += die.value
	for value in range(1,7):
		if value == 1 and !values.has(value) and _1_er_value.text == "":
			_1_er_button.disabled = true
		if value == 2 and !values.has(value) and _2_er_value.text == "":
			_2_er_button.disabled = true
		if value == 3 and !values.has(value) and _3_er_value.text == "":
			_3_er_button.disabled = true
		if value == 4 and !values.has(value) and _4_er_value.text == "":
			_4_er_button.disabled = true
		if value == 5 and !values.has(value) and _5_er_value.text == "":
			_5_er_button.disabled = true
		if value == 6 and !values.has(value) and _6_er_value.text == "":
			_6_er_button.disabled = true
	kl_str_button.disabled = true
	gr_str_button.disabled = true
	if values.has(1):
		if values.has(2):
			if values.has(3):
				if values.has(4):
					kl_str_button.disabled = false
					if values.has(5):
						gr_str_button.disabled = false
	elif values.has(2):
		if values.has(3):
			if values.has(4):
				if values.has(5):
					kl_str_button.disabled = false
					if values.has(6):
						gr_str_button.disabled = false
	elif values.has(3):
		if values.has(4):
			if values.has(5):
				if values.has(6):
					kl_str_button.disabled = false
	if chance_value.text == "":
		chance_button.disabled = false
	else:
		chance_button.disabled = true
	dice_counts = [0, 0, 0, 0, 0, 0]
	for value in values:
		dice_counts[value-1] += 1
	if dice_counts.has(3) and _3_er_pasch_value.text == "":
		_3_er_pasch_button.disabled = false
	else:
		_3_er_pasch_button.disabled = true
	if dice_counts.has(4) and _4_er_pasch_value.text == "":
		_4_er_pasch_button.disabled = false
		if _3_er_pasch_value.text == "":
			_3_er_pasch_button.disabled = false
		else:
			_3_er_pasch_button.disabled = true
	else:
		_4_er_pasch_button.disabled = true
	if dice_counts.has(2) and dice_counts.has(3) and fh_value.text == "":
		fh_button.disabled = false
	else:
		fh_button.disabled = true
	if dice_counts.has(5) and (kniffel_value.text == "" or kniffel_value.text != "0"):
		kniffel_button.disabled = false
		if _4_er_pasch_value.text == "":
			_4_er_pasch_button.disabled = false
		else:
			_4_er_pasch_button.disabled = true
		if _3_er_pasch_value.text == "":
			_3_er_pasch_button.disabled = false
		else:
			_3_er_pasch_button.disabled = true
	else:
		kniffel_button.disabled = true


func _on_show_sums_button_pressed() -> void:
	show_sums = !show_sums
	sums_container.visible = show_sums


#func _check_next_round() -> void:
#	$CanvasLayer/Panel/NextRoundButton.text = "Nächste Runde"
	

func _on_1er_button_pressed() -> void:
	var sum = 0
	for die in dice:
		if die.value == 1:
			sum += 1
	_1_er_value.text = str(sum)
	$GamePanel/Delete1Button.visible = false
	_disable_all()
	_next_round()


func _on_2er_button_pressed() -> void:
	var sum = 0
	for die in dice:
		if die.value == 2:
			sum += 2
	_2_er_value.text = str(sum)
	$GamePanel/Delete2Button.visible = false
	_disable_all()
	_next_round()


func _on_3er_button_pressed() -> void:
	var sum = 0
	for die in dice:
		if die.value == 3:
			sum += 3
	_3_er_value.text = str(sum)
	$GamePanel/Delete3Button.visible = false
	_disable_all()
	_next_round()


func _on_4er_button_pressed() -> void:
	var sum = 0
	for die in dice:
		if die.value == 4:
			sum += 4
	_4_er_value.text = str(sum)
	$GamePanel/Delete4Button.visible = false
	_disable_all()
	_next_round()


func _on_5er_button_pressed() -> void:
	var sum = 0
	for die in dice:
		if die.value == 5:
			sum += 5
	_5_er_value.text = str(sum)
	$GamePanel/Delete5Button.visible = false
	_disable_all()
	_next_round()


func _on_6er_button_pressed() -> void:
	var sum = 0
	for die in dice:
		if die.value == 6:
			sum += 6
	_6_er_value.text = str(sum)
	$GamePanel/Delete6Button.visible = false
	_disable_all()
	_next_round()


func _on_timer_timeout():
	_check_values()


func _on_next_round_button_pressed() -> void:
	$CanvasLayer/NextRoundPanel.visible = false
	_load_player()
	if game_round < 14 and current_player == 0:
		game_round += 1
	player_round = 1
	_update_player_label()
	_reset_dice()
	_roll_dice()
	$Timer.start()


func _reset_dice():
	keep_ids.clear()
	for die in dice:
		die.position = die.start_position
		die.roll()


func _on_3er_pasch_button_pressed() -> void:
	_3_er_pasch_value.text = str(sum_all_dice)
	$GamePanel/Delete3PButton.visible = false
	_disable_all()
	_next_round()
	

func _on_4er_pasch_button_pressed() -> void:
	_4_er_pasch_value.text = str(sum_all_dice)
	$GamePanel/Delete4PButton.visible = false
	_disable_all()
	_next_round()


func _on_kl_str_button_pressed() -> void:
	kl_str_value.text = str(30)
	$GamePanel/DeleteKlStrButton.visible = false
	_disable_all()
	_next_round()


func _on_gr_str_button_pressed() -> void:
	gr_str_value.text = str(40)
	$GamePanel/DeleteGrStrButton.visible = false
	_disable_all()
	_next_round()


func _on_fh_button_pressed() -> void:
	fh_value.text = str(25)
	$GamePanel/DeleteFhButton.visible = false
	_disable_all()
	_next_round()


#TODO: multiple kniffel
func _on_kniffel_button_pressed() -> void:
	kniffel_value.text = str(50)
	$GamePanel/DeleteKnButton.visible = false
	_disable_all()
	_next_round()


func _on_chance_button_pressed() -> void:
	chance_value.text = str(sum_all_dice)
	$GamePanel/DeleteChButton.visible = false
	_disable_all()
	_next_round()


func _on_keep_area_area_entered(area) -> void:
	if area.is_in_group("dice_group"):
		var die = area.get_parent()
		keep_ids.append(die.id)


func _on_keep_area_area_exited(area) -> void:
	if area.is_in_group("dice_group"):
		var die = area.get_parent()
		if keep_ids.has(die.id):
			keep_ids.erase(die.id)


func _on_new_roll_dice_button_pressed() -> void:
	player_round += 1
	$Timer.start()
	if player_round < 4:
		_update_player_label()
		for die in dice:
			if keep_ids.is_empty():
				die.start_rolling()
			elif !keep_ids.has(die.id):
				die.start_rolling()


func _roll_dice() -> void:
	for die in dice:
		if keep_ids.is_empty():
			die.start_rolling()
		elif !keep_ids.has(die.id):
			die.start_rolling()


func _save_player() -> void:
	if _1_er_value.text != "":
		if _1_er_value.text == "0":
			players[current_player]._1er = -1
		else:
			players[current_player]._1er = int(_1_er_value.text)
	else:
		players[current_player]._1er = 0
	if _2_er_value.text != "":
		if _2_er_value.text == "0":
			players[current_player]._2er = -1
		else:
			players[current_player]._2er = int(_2_er_value.text)
	else:
		players[current_player]._2er = 0
	if _3_er_value.text != "":
		if _3_er_value.text == "0":
			players[current_player]._3er = -1
		else:
			players[current_player]._3er = int(_3_er_value.text)
	else:
		players[current_player]._3er = 0
	if _4_er_value.text != "":
		if _4_er_value.text == "0":
			players[current_player]._4er = -1
		else:
			players[current_player]._4er = int(_4_er_value.text)
	else:
		players[current_player]._4er = 0
	if _5_er_value.text != "":
		if _5_er_value.text == "0":
			players[current_player]._5er = -1
		else:
			players[current_player]._5er = int(_5_er_value.text)
	else:
		players[current_player]._5er = 0
	if _6_er_value.text != "":
		if _6_er_value.text == "0":
			players[current_player]._6er = -1
		else:
			players[current_player]._6er = int(_6_er_value.text)
	else:
		players[current_player]._6er = 0
	if _3_er_pasch_value.text != "":
		if _3_er_pasch_value.text == "0":
			players[current_player]._3er_pasch = -1
		else:
			players[current_player]._3er_pasch = int(_3_er_pasch_value.text)
	else:
		players[current_player]._3er_pasch = 0
	if _4_er_pasch_value.text != "":
		if _4_er_pasch_value.text == "0":
			players[current_player]._4er_pasch = -1
		else:
			players[current_player]._4er_pasch = int(_4_er_pasch_value.text)
	else:
		players[current_player]._4er_pasch = 0
	if kl_str_value.text != "":
		if kl_str_value.text == "0":
			players[current_player]._kl_str = -1
		else:
			players[current_player]._kl_str = int(kl_str_value.text)
	else:
		players[current_player]._kl_str = 0
	if gr_str_value.text != "":
		if gr_str_value.text == "0":
			players[current_player]._gr_str = -1
		else:
			players[current_player]._gr_str = int(gr_str_value.text)
	else:
		players[current_player]._gr_str = 0
	if fh_value.text != "":
		if fh_value.text == "0":
			players[current_player]._fh = -1
		else:
			players[current_player]._fh = int(fh_value.text)
	else:
		players[current_player]._fh = 0
	if kniffel_value.text != "":
		if kniffel_value.text == "0":
			players[current_player]._kniffel = -1
		else:
			players[current_player]._kniffel = int(kniffel_value.text)
	else:
		players[current_player]._kniffel = 0
	if chance_value.text != "":
		if chance_value.text == "0":
			players[current_player]._chance = -1
		else:
			players[current_player]._chance = int(chance_value.text)
	else:
		players[current_player]._chance = 0
	players[current_player]._sum_up = sum_top
	players[current_player]._sum_bottom = sum_bottom
	players[current_player]._bonus = bonus
	players[current_player]._sum_total = total_sum


func _load_player() -> void:
	if players[current_player]._1er == -1:
		_1_er_value.text = "0"
		$GamePanel/Delete1Button.visible = false
	elif players[current_player]._1er == 0:
		_1_er_value.text = ""
		$GamePanel/Delete1Button.visible = true
	else:
		_1_er_value.text = str(players[current_player]._1er)
		$GamePanel/Delete1Button.visible = false
	if players[current_player]._2er == -1:
		_2_er_value.text = "0"
		$GamePanel/Delete2Button.visible = false
	elif players[current_player]._2er == 0:
		_2_er_value.text = ""
		$GamePanel/Delete2Button.visible = true
	else:
		_2_er_value.text = str(players[current_player]._2er)
		$GamePanel/Delete2Button.visible = false
	if players[current_player]._3er == -1:
		_3_er_value.text = "0"
		$GamePanel/Delete3Button.visible = false
	elif players[current_player]._3er == 0:
		_3_er_value.text = ""
		$GamePanel/Delete3Button.visible = true
	else:
		_3_er_value.text = str(players[current_player]._3er)
		$GamePanel/Delete3Button.visible = false
	if players[current_player]._4er == -1:
		_4_er_value.text = "0"
		$GamePanel/Delete4Button.visible = false
	elif players[current_player]._4er == 0:
		_4_er_value.text = ""
		$GamePanel/Delete4Button.visible = true
	else:
		_4_er_value.text = str(players[current_player]._4er)
		$GamePanel/Delete4Button.visible = false
	if players[current_player]._5er == -1:
		_5_er_value.text = "0"
		$GamePanel/Delete5Button.visible = false
	elif players[current_player]._5er == 0:
		_5_er_value.text = ""
		$GamePanel/Delete5Button.visible = true
	else:
		_5_er_value.text = str(players[current_player]._5er)
		$GamePanel/Delete5Button.visible = false
	if players[current_player]._6er == -1:
		_6_er_value.text = "0"
		$GamePanel/Delete6Button.visible = false
	elif players[current_player]._6er == 0:
		_6_er_value.text = ""
		$GamePanel/Delete6Button.visible = true
	else:
		_6_er_value.text = str(players[current_player]._6er)
		$GamePanel/Delete6Button.visible = false
	if players[current_player]._3er_pasch == -1:
		_3_er_pasch_value.text = "0"
		$GamePanel/Delete3PButton.visible = false
	elif players[current_player]._3er_pasch == 0:
		_3_er_pasch_value.text = ""
		$GamePanel/Delete3PButton.visible = true
	else:
		_3_er_pasch_value.text = str(players[current_player]._3er_pasch)
		$GamePanel/Delete3PButton.visible = false
	if players[current_player]._4er_pasch == -1:
		_4_er_pasch_value.text = "0"
		$GamePanel/Delete4PButton.visible = false
	elif players[current_player]._4er_pasch == 0:
		_4_er_pasch_value.text = ""
		$GamePanel/Delete4PButton.visible = true
	else:
		_4_er_pasch_value.text = str(players[current_player]._4er_pasch)
		$GamePanel/Delete4PButton.visible = false
	if players[current_player]._kl_str == -1:
		kl_str_value.text = "0"
		$GamePanel/DeleteKlStrButton.visible = false
	elif players[current_player]._kl_str == 0:
		kl_str_value.text = ""
		$GamePanel/DeleteKlStrButton.visible = true
	else:
		kl_str_value.text = str(players[current_player]._kl_str)
		$GamePanel/DeleteKlStrButton.visible = false
	if players[current_player]._gr_str == -1:
		gr_str_value.text = "0"
		$GamePanel/DeleteGrStrButton.visible = false
	elif players[current_player]._gr_str == 0:
		gr_str_value.text = ""
		$GamePanel/DeleteGrStrButton.visible = true
	else:
		gr_str_value.text = str(players[current_player]._gr_str)
		$GamePanel/DeleteGrStrButton.visible = false
	if players[current_player]._fh == -1:
		fh_value.text = "0"
		$GamePanel/DeleteFhButton.visible = false
	elif players[current_player]._fh == 0:
		fh_value.text = ""
		$GamePanel/DeleteFhButton.visible = true
	else:
		fh_value.text = str(players[current_player]._fh)
		$GamePanel/DeleteFhButton.visible = false
	if players[current_player]._kniffel == -1:
		kniffel_value.text = "0"
		$GamePanel/DeleteKnButton.visible = false
	elif players[current_player]._kniffel == 0:
		kniffel_value.text = ""
		$GamePanel/DeleteKnButton.visible = true
	else:
		kniffel_value.text = str(players[current_player]._kniffel)
		$GamePanel/DeleteKnButton.visible = false
	if players[current_player]._chance == -1:
		chance_value.text = "0"
		$GamePanel/DeleteChButton.visible = false
	elif players[current_player]._chance == 0:
		chance_value.text = ""
		$GamePanel/DeleteChButton.visible = true
	else:
		chance_value.text = str(players[current_player]._chance)
		$GamePanel/DeleteChButton.visible = false
	_calc_sums()


func _on_new_game_button_pressed():
	$CanvasLayer/NewGamePanel/VBoxContainer.visible = false
	$CanvasLayer/NewGamePanel/VBoxContainer2.visible = true


func _on_highscore_button_pressed():
	pass # Replace with function body.


func _on_exit_button_pressed():
	get_tree().quit()


func _on_continue_button_pressed():
	#player_count = int($CanvasLayer/NewGamePanel/VBoxContainer2/CountPlayersLineEdit.text)
	$CanvasLayer/NewGamePanel/VBoxContainer2.visible = false
	$CanvasLayer/NewGamePanel/VBoxContainer3.visible = true
	current_player = 0
	$CanvasLayer/NewGamePanel/VBoxContainer3/PlayernameLineEdit.text = "Spieler " + str(current_player + 1)


func _on_continue_button_2_pressed():
	var player = Player.new($CanvasLayer/NewGamePanel/VBoxContainer3/PlayernameLineEdit.text)
	players.append(player)
	current_player += 1
	if current_player < player_count:
		$CanvasLayer/NewGamePanel/VBoxContainer3/PlayernameLineEdit.text = "Spieler " + str(current_player + 1)
	else:
		$CanvasLayer/NewGamePanel.visible = false
		$GamePanel.visible = true
		$RenewArea.visible = true
		$KeepArea.visible = true
		die_0.visible = true
		die_1.visible = true
		die_2.visible = true
		die_3.visible = true
		die_4.visible = true
		#$CanvasLayer/NewGamePanel/VBoxContainer3.visible = false
		current_player = 0
		_start_game()


func _on_count_players_line_edit_text_changed(new_text):
	if new_text.is_valid_int():
		player_count = int(new_text)
		$CanvasLayer/NewGamePanel/VBoxContainer2/ContinueButton.disabled = false
	else:
		$CanvasLayer/NewGamePanel/VBoxContainer2/ContinueButton.disabled = true


func _on_delete_1_button_pressed():
	_1_er_value.text = str(0)
	$GamePanel/Delete1Button.visible = false
	_disable_all()
	_next_round()


func _on_delete_2_button_pressed():
	_2_er_value.text = str(0)
	$GamePanel/Delete2Button.visible = false
	_disable_all()
	_next_round()


func _on_delete_3_button_pressed():
	_3_er_value.text = str(0)
	$GamePanel/Delete3Button.visible = false
	_disable_all()
	_next_round()


func _on_delete_4_button_pressed():
	_4_er_value.text = str(0)
	$GamePanel/Delete4Button.visible = false
	_disable_all()
	_next_round()


func _on_delete_5_button_pressed():
	_5_er_value.text = str(0)
	$GamePanel/Delete5Button.visible = false
	_disable_all()
	_next_round()


func _on_delete_6_button_pressed():
	_6_er_value.text = str(0)
	$GamePanel/Delete6Button.visible = false
	_disable_all()
	_next_round()


func _on_delete_3p_button_pressed():
	_3_er_pasch_value.text = str(0)
	$GamePanel/Delete3PButton.visible = false
	_disable_all()
	_next_round()


func _on_delete_4p_button_pressed():
	_4_er_pasch_value.text = str(0)
	$GamePanel/Delete4PButton.visible = false
	_disable_all()
	_next_round()


func _on_delete_kl_str_button_pressed():
	kl_str_value.text = str(0)
	$GamePanel/DeleteKlStrButton.visible = false
	_disable_all()
	_next_round()


func _on_delete_gr_str_button_pressed():
	gr_str_value.text = str(0)
	$GamePanel/DeleteGrStrButton.visible = false
	_disable_all()
	_next_round()


func _on_delete_fh_button_pressed():
	fh_value.text = str(0)
	$GamePanel/DeleteFhButton.visible = false
	_disable_all()
	_next_round()


func _on_delete_kn_button_pressed():
	kniffel_value.text = str(0)
	$GamePanel/DeleteKnButton.visible = false
	_disable_all()
	_next_round()


func _on_delete_ch_button_pressed():
	chance_value.text = str(0)
	$GamePanel/DeleteChButton.visible = false
	_disable_all()
	_next_round()
