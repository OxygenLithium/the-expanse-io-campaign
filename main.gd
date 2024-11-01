extends Node

@export var map_canvas : CanvasLayer
@export var hud_canvas : CanvasLayer

var frigateFile = load("res://scenes/unn_frigate.tscn")
var cruiserFile = load("res://scenes/trenton_cruiser.tscn")

var UNNShips = []
var MCRNShips = []

var gameOver = false

func player_death():
	if gameOver:
		return
	var gameOver = true
	map_canvas.visible = false
	hud_canvas.player_death()
	
func victory():
	if gameOver:
		return
	var gameOver = true
	map_canvas.visible = false
	hud_canvas.victory()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#UI
	var gameOver = false
	map_canvas.visible = true
	hud_canvas.visible = true
	
	#for i in range(3):
		#var enemy = frigateFile.instantiate()
		#enemy.position = Vector2(10000,-1000 + 1000*i)
		#add_child(enemy)
	
	var enemy = frigateFile.instantiate()
	enemy.position = Vector2(25000,-100)
	add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(25000,200)
	add_child(enemy)
	
	enemy = cruiserFile.instantiate()
	enemy.position = Vector2(26000,000)
	add_child(enemy)
	
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(-108000,-250)
	#add_child(enemy)
	#
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(15000,10000)
	#add_child(enemy)
	#
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(17000,8000)
	#add_child(enemy)
	#return

func unn_ship_destroyed():
	if UNNShips.size() < 1:
		victory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
