class_name Player extends Node

var player_name: String

var _1er: int
var _2er: int
var _3er: int
var _4er: int
var _5er: int
var _6er: int
var _3er_pasch: int
var _4er_pasch: int
var _kl_str: int
var _gr_str: int
var _fh: int
var _kniffel: int
var _chance: int
var _round: int

var _sum_up: int
var _sum_bottom: int
var _bonus: int
var _sum_total: int


func _init(p_name: String):
	player_name = p_name
	_1er = 0
	_2er = 0
	_3er = 0
	_4er = 0
	_5er = 0
	_6er = 0
	_3er_pasch = 0
	_4er_pasch = 0
	_kl_str = 0
	_gr_str = 0
	_kniffel = 0
	_fh = 0
	_chance = 0
	_round = 1
