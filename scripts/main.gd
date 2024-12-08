extends Node

@export var map_canvas : CanvasLayer
@export var hud_canvas : CanvasLayer
@export var message_canvas : CanvasLayer
@export var player : Node2D

var level = 1

#UNN Ships
var mulanFile = load("res://scenes/ships/unn/unn_frigate.tscn")
var andronicusFile = load("res://scenes/ships/unn/andronicus_destroyer.tscn")
var munroeFile = load("res://scenes/ships/unn/munroe_frigate.tscn")
var murphyFile = load("res://scenes/ships/unn/murphy_destroyer.tscn")
var trentonFile = load("res://scenes/ships/unn/trenton_cruiser.tscn")
var asimovFile = load("res://scenes/ships/unn/asimov_cruiser.tscn")

#MCRN Ships
var corvetteFile = load("res://scenes/ships/mcrn/corvette.tscn")
var sciroccoFile = load("res://scenes/ships/mcrn/scirocco.tscn")

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
		#var enemy = mulanFile.instantiate()
		#enemy.position = Vector2(10000,-1000 + 1000*i)
		#add_child(enemy)
	
	var enemy = null
	var ally = null
	
	if level == 1:
		addMulan(Vector2(20000,1500), "UNN Ashgrove")
		addMulan(Vector2(22000,3000), "UNN Ibadan")
		addMulan(Vector2(22000,0), "UNN Riemann")
		
	elif level == 2:
		addMulan(Vector2(22000,1500), "UNN Honolulu")
		addMulan(Vector2(22000,-1500), "UNN Arthur Cayley")
		addMulan(Vector2(20000,0), "UNN Triangulum")
	
		addAndronicus(Vector2(23500,-500), "UNN Rawlinson")
		addTrenton(Vector2(24000,0), "UNN Daegu")
		addAndronicus(Vector2(23500,500), "UNN Horatio")
		
	elif level == 3:
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(20000,1500)
		enemy.displayName = "UNN Nightwing"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(20000,0)
		enemy.displayName = "UNN Beirut"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(30000,700)
		enemy.displayName = "UNN Terence Moe"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(30000,5000)
		enemy.displayName = "UNN Senden"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(30000,-5000)
		enemy.displayName = "UNN Raiden"
		add_child(enemy)
		
		enemy = asimovFile.instantiate()
		enemy.position = Vector2(32000,1000)
		enemy.displayName = "UNN Ursula Le Guin"
		add_child(enemy)
		
		enemy = trentonFile.instantiate()
		enemy.position = Vector2(35000,1000)
		enemy.displayName = "UNN Stockholm"
		add_child(enemy)
		
		enemy = trentonFile.instantiate()
		enemy.position = Vector2(35000,-1000)
		enemy.displayName = "UNN Salem"
		add_child(enemy)
		
	elif level == 4:
		ally = corvetteFile.instantiate()
		ally.position = Vector2(-800,400)
		ally.displayName = "MCRN Wukong"
		add_child(ally)
		
		ally = corvetteFile.instantiate()
		ally.position = Vector2(-800,-400)
		ally.displayName = "MCRN Raiden"
		add_child(ally)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(13500,1500)
		enemy.displayName = "UNN Milton"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(12000,0)
		enemy.displayName = "UNN Jasper"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
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
		enemy.position = Vector2(70000,-5000)
		enemy.displayName = "UNN Hou Yi"
		add_child(enemy)
		
		enemy = trentonFile.instantiate()
		enemy.position = Vector2(60000,1500)
		enemy.displayName = "UNN Katyusha"
		add_child(enemy)
		
		enemy = trentonFile.instantiate()
		enemy.position = Vector2(60000,-1500)
		enemy.displayName = "UNN Chelyabinsk"
		add_child(enemy)
		
	elif level == 5:
		ally = corvetteFile.instantiate()
		ally.position = Vector2(-800,400)
		ally.displayName = "MCRN Wukong"
		add_child(ally)
		
		ally = corvetteFile.instantiate()
		ally.position = Vector2(-800,-400)
		ally.displayName = "MCRN Raiden"
		add_child(ally)
		
		ally = corvetteFile.instantiate()
		ally.position = Vector2(-1600,800)
		ally.displayName = "MCRN Hester Prynne"
		add_child(ally)
		
		ally = sciroccoFile.instantiate()
		ally.position = Vector2(-2400,0)
		ally.displayName = "MCRN Amazon"
		add_child(ally)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(13500,1500)
		enemy.displayName = "UNN Milton"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(14500,2500)
		enemy.displayName = "UNN Milton"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(12000,0)
		enemy.displayName = "UNN Jasper"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(13500,-1500)
		enemy.displayName = "UNN Beirut"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(14500,-2500)
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
		enemy.position = Vector2(40000,-5000)
		enemy.displayName = "UNN Hou Yi"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(50000,-5000)
		enemy.displayName = "UNN Austin"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(50000,-6000)
		enemy.displayName = "UNN Chelsea"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(50000,-4000)
		enemy.displayName = "UNN San Jose"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(50000,-3000)
		enemy.displayName = "UNN Donald Knuth"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(50000,-2000)
		enemy.displayName = "UNN Mary Shelley"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(52000,-6000)
		enemy.displayName = "UNN Hayha"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(52000,-5000)
		enemy.displayName = "UNN Basilic"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(53000,-4000)
		enemy.displayName = "UNN Typhoon"
		add_child(enemy)

func unn_ship_destroyed():
	if UNNShips.size() < 1:
		victory()

#Add UNN ship
func addMulan(ePos, eName, eMode = "active"):
	var enemy = mulanFile.instantiate()
	enemy.position = ePos
	enemy.name = eName
	enemy.mode = eMode
	add_child(enemy)

func addMunroe(ePos, eName, eMode = "active"):
	var enemy = munroeFile.instantiate()
	enemy.position = ePos
	enemy.name = eName
	enemy.mode = eMode
	add_child(enemy)

func addAndronicus(ePos, eName, eMode = "active"):
	var enemy = andronicusFile.instantiate()
	enemy.position = ePos
	enemy.name = eName
	enemy.mode = eMode
	add_child(enemy)
	
func addMurphy(ePos, eName, eMode = "active"):
	var enemy = murphyFile.instantiate()
	enemy.position = ePos
	enemy.name = eName
	enemy.mode = eMode
	add_child(enemy)

func addTrenton(ePos, eName, eMode = "active"):
	var enemy = trentonFile.instantiate()
	enemy.position = ePos
	enemy.name = eName
	enemy.mode = eMode
	add_child(enemy)

func addAsimov(ePos, eName, eMode = "active"):
	var enemy = asimovFile.instantiate()
	enemy.position = ePos
	enemy.name = eName
	enemy.mode = eMode
	add_child(enemy)


#Add MCRN ships
func addCorvette(ePos, eName, eMode = "active"):
	var ally = corvetteFile.instantiate()
	ally.position = ePos
	ally.name = eName
	ally.mode = eMode
	add_child(ally)

func addScirocco(ePos, eName, eMode = "active"):
	var ally = sciroccoFile.instantiate()
	ally.position = ePos
	ally.name = eName
	ally.mode = eMode
	add_child(ally)
