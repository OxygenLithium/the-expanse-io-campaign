extends Node

@export var map_canvas : CanvasLayer
@export var hud_canvas : CanvasLayer

var frigateFile = load("res://scenes/unn_frigate.tscn")
var andronicusFile = load("res://scenes/andronicus_destroyer.tscn")
var destroyerFile = load("res://scenes/murphy_destroyer.tscn")
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
	
	var enemy = null
	
	#enemy = destroyerFile.instantiate()
	#enemy.position = Vector2(-300,300)
	#add_child(enemy)
	#
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(300,300)
	#add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(20000,400)
	enemy.displayName = "UNN Nightwing"
	add_child(enemy)
	
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(20000,-800)
	#enemy.displayName = "UNN Balsamic Vinegar"
	#add_child(enemy)
	#
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(20000,800)
	#enemy.displayName = "UNN Sundial"
	#add_child(enemy)
	
	#enemy = destroyerFile.instantiate()
	#enemy.position = Vector2(26000,-100)
	#add_child(enemy)
	
	#enemy = destroyerFile.instantiate()
	#enemy.position = Vector2(20000,0)
	#add_child(enemy)
	
	#enemy = andronicusFile.instantiate()
	#enemy.position = Vector2(22000,2000)
	#enemy.displayName = "UNN Chad Japeeti"
	#add_child(enemy)
	#
	#enemy = destroyerFile.instantiate()
	#enemy.position = Vector2(22000,0)
	#enemy.displayName = "UNN Cyra Practer"
	#add_child(enemy)
	
	#enemy = cruiserFile.instantiate()
	#enemy.position = Vector2(25500,000)
	#add_child(enemy)
	
	#enemy = frigateFile.instantiate()
	#enemy.position = Vector2(20000,0)
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
