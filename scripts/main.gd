extends Node

@export var map_canvas : CanvasLayer
@export var hud_canvas : CanvasLayer
@export var message_canvas : CanvasLayer
@export var player : Node2D

var level = 1

var frigateFile = load("res://scenes/ships/unn/unn_frigate.tscn")
var andronicusFile = load("res://scenes/ships/unn/andronicus_destroyer.tscn")
var munroeFile = load("res://scenes/ships/unn/munroe_frigate.tscn")
var murphyFile = load("res://scenes/ships/unn/murphy_destroyer.tscn")
var cruiserFile = load("res://scenes/ships/unn/trenton_cruiser.tscn")

var UNNShips = []
var MCRNShips = []

var gameOver = false

func player_death():
	if gameOver:
		return
	gameOver = true
	map_canvas.visible = false
	hud_canvas.visible = false
	message_canvas.missionFailed()
	
func victory():
	if gameOver:
		return
	gameOver = true
	map_canvas.visible = false
	hud_canvas.visible = false
	message_canvas.missionAccomplished()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_enter"):
		if gameOver:
			queue_free()
			get_parent().reset()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#UI
	gameOver = false
	map_canvas.visible = true
	hud_canvas.visible = true
	message_canvas.visible = true
	
	#for i in range(3):
		#var enemy = frigateFile.instantiate()
		#enemy.position = Vector2(10000,-1000 + 1000*i)
		#add_child(enemy)
	
	var enemy = null
	
	if level == 1:
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(20000,1500)
		enemy.displayName = "UNN Ashgrove"
		add_child(enemy)
		
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(22000,3000)
		enemy.displayName = "UNN Ibadan"
		add_child(enemy)
		
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(22000,0)
		enemy.displayName = "UNN Nathaniel Palmer"
		add_child(enemy)
		
	if level == 2:
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(20000,1500)
		enemy.displayName = "UNN Honolulu"
		add_child(enemy)
		
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(20000,-1500)
		enemy.displayName = "UNN Arthur Cayley"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(24000,0)
		enemy.displayName = "UNN Triangulum"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(22000,-2000)
		enemy.displayName = "UNN Heron"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(22000,2000)
		enemy.displayName = "UNN Ball Lightning"
		add_child(enemy)
		
	elif level == 3:
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(20000,1500)
		enemy.displayName = "UNN Nightwing"
		add_child(enemy)
		
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(20000,0)
		enemy.displayName = "UNN Beirut"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(30000,700)
		enemy.displayName = "UNN Terence Moe"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(30000,5000)
		enemy.displayName = "UNN Branta"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(30000,-5000)
		enemy.displayName = "UNN Mantis"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(45000,-5000)
		enemy.displayName = "UNN Lafayette"
		add_child(enemy)
		
	elif level == 4:
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(13500,1500)
		enemy.displayName = "UNN Milton"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(12000,0)
		enemy.displayName = "UNN Jasper"
		add_child(enemy)
		
		enemy = frigateFile.instantiate()
		enemy.position = Vector2(13500,-1500)
		enemy.displayName = "UNN Beirut"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(20000,700)
		enemy.displayName = "UNN St. Elmo's Fire"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(20000,-700)
		enemy.displayName = "UNN Maracaibo"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(24000,0)
		enemy.displayName = "UNN Beowulf"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(80000,-5000)
		enemy.displayName = "UNN Hou Yi"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(150000,-6000)
		enemy.displayName = "UNN Hayha"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(140000,-5000)
		enemy.displayName = "UNN Basilic"
		add_child(enemy)

func unn_ship_destroyed():
	if UNNShips.size() < 1:
		victory()
