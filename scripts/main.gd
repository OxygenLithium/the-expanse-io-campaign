extends Node

@export var map_canvas : CanvasLayer
@export var hud_canvas : CanvasLayer
@export var message_canvas : CanvasLayer

var frigateFile = load("res://scenes/ships/unn/unn_frigate.tscn")
var andronicusFile = load("res://scenes/ships/unn/andronicus_destroyer.tscn")
var munroeFile = load("res://scenes/ships/unn/munroe_frigate.tscn")
var destroyerFile = load("res://scenes/ships/unn/murphy_destroyer.tscn")
var cruiserFile = load("res://scenes/ships/unn/trenton_cruiser.tscn")

var UNNShips = []
var MCRNShips = []

var gameOver = false

func player_death():
	if gameOver:
		return
	var gameOver = true
	map_canvas.visible = false
	message_canvas.missionFailed()
	
func victory():
	if gameOver:
		return
	var gameOver = true
	map_canvas.visible = false
	message_canvas.missionAccomplished()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#UI
	var gameOver = false
	map_canvas.visible = true
	hud_canvas.visible = true
	message_canvas.visible = true
	
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
	enemy.position = Vector2(20000,1500)
	enemy.displayName = "UNN Nightwing"
	add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(20000,0)
	enemy.displayName = "UNN Balsamic Vinegar"
	add_child(enemy)

	enemy = frigateFile.instantiate()
	enemy.position = Vector2(20000,-1500)
	enemy.displayName = "UNN Sundial"
	add_child(enemy)
	
	enemy = andronicusFile.instantiate()
	enemy.position = Vector2(20000,700)
	enemy.displayName = "UNN T. Moe"
	add_child(enemy)
	
	enemy = munroeFile.instantiate()
	enemy.position = Vector2(20000,5000)
	enemy.displayName = "UNN Branta"
	add_child(enemy)
	
	enemy = munroeFile.instantiate()
	enemy.position = Vector2(30000,-5000)
	enemy.displayName = "UNN Canada Goose"
	add_child(enemy)

func unn_ship_destroyed():
	if UNNShips.size() < 1:
		victory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass