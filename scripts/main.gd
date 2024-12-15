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
var morriganFile = load("res://scenes/ships/mcrn/morrigan.tscn")
var corvetteFile = load("res://scenes/ships/mcrn/corvette.tscn")
var raptorFile = load("res://scenes/ships/mcrn/raptor.tscn")
var sciroccoFile = load("res://scenes/ships/mcrn/scirocco.tscn")
var donnagerFile = load("res://scenes/ships/mcrn/donnager.tscn")

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
		addMulan(Vector2(100000,6000), "UNN Ashgrove")
		addMulan(Vector2(11000,12000), "UNN Ibadan")
		addMulan(Vector2(110000,0), "UNN Riemann")
		
	elif level == 2:
		addMorrigan(Vector2(-1600,800), "MCRN Scipio Africanus")
		
		addMulan(Vector2(11000,6000), "UNN Honolulu")
		addMulan(Vector2(11000,-6000), "UNN Arthur Cayley")
		addMulan(Vector2(100000,0), "UNN Triangulum")
	
		addAndronicus(Vector2(114000,-2000), "UNN Rawlinson")
		addTrenton(Vector2(116000,0), "UNN Daegu")
		addAndronicus(Vector2(114000,2000), "UNN Horatio")
		
	elif level == 3:
		addCorvette(Vector2(-1600,800), "MCRN Wukong")
		addCorvette(Vector2(-1600,-800), "UNN Nightwing")
		
		addMulan(Vector2(100000,0), "UNN Beirut")
		addAndronicus(Vector2(140000,700), "UNN Terence Moe")
		addMunroe(Vector2(140000,20000), "UNN Senden")
		addMunroe(Vector2(140000,-20000), "UNN Raiden")
		addMunroe(Vector2(148000,4000), "UNN Ursula Le Guin")
		addTrenton(Vector2(160000,4000), "UNN Stockholm")
		addTrenton(Vector2(160000,-4000), "UNN Salem")
		
	elif level == 4:
		addCorvette(Vector2(-1600,800), "MCRN Wukong")
		addCorvette(Vector2(-1600,-800), "UNN Nightwing")
		
		addMulan(Vector2(108000,6000), "UNN Milton")
		addMulan(Vector2(10600,0), "UNN Jasper")
		addMulan(Vector2(108000,-6000), "UNN Beirut")
		addMunroe(Vector2(140000,-6000), "UNN St. Elmo's Fire")
		addMunroe(Vector2(140000, 6000), "UNN Maracaibo")
		
		addAndronicus(Vector2(180000,0), "UNN Maracaibo")
		addAndronicus(Vector2(180000,0), "UNN Hou Yi")
		
		addTrenton(Vector2(200000,6000), "UNN Katyusha")
		addTrenton(Vector2(200000,-6000), "UNN Chelyabinsk")
		
	elif level == 5:
		addCorvette(Vector2(-1600,800), "MCRN Wukong")
		addMorrigan(Vector2(-1600,-800), "MCRN Nagamaki")
		addMorrigan(Vector2(-3200,1600), "MCRN Hester Prynne")
		#addDonnager(Vector2(-500,-300), "MCRN Ragnarok")
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(54000,6000)
		enemy.displayName = "UNN Milton"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(54000,10000)
		enemy.displayName = "UNN Milton"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(48000,0)
		enemy.displayName = "UNN Jasper"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(54000,-6000)
		enemy.displayName = "UNN Beirut"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(58000,-10000)
		enemy.displayName = "UNN Beirut"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(80000,2800)
		enemy.displayName = "UNN St. Elmo's Fire"
		add_child(enemy)
		
		enemy = munroeFile.instantiate()
		enemy.position = Vector2(80000,-2800)
		enemy.displayName = "UNN Maracaibo"
		add_child(enemy)
		
		enemy = andronicusFile.instantiate()
		enemy.position = Vector2(96000,0)
		enemy.displayName = "UNN Beowulf"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(160000,-20000)
		enemy.displayName = "UNN Hou Yi"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(200000,-20000)
		enemy.displayName = "UNN Austin"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(200000,-24000)
		enemy.displayName = "UNN Chelsea"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(200000,-16000)
		enemy.displayName = "UNN San Jose"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(200000,-12000)
		enemy.displayName = "UNN Donald Knuth"
		add_child(enemy)
		
		enemy = mulanFile.instantiate()
		enemy.position = Vector2(200000,-8000)
		enemy.displayName = "UNN Mary Shelley"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(208000,-24000)
		enemy.displayName = "UNN Hayha"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(208000,-20000)
		enemy.displayName = "UNN Basilic"
		add_child(enemy)
		
		enemy = murphyFile.instantiate()
		enemy.position = Vector2(212000,-16000)
		enemy.displayName = "UNN Typhoon"
		add_child(enemy)

func unn_ship_destroyed():
	if UNNShips.size() < 1:
		victory()

#Add UNN ship
func addMulan(ePos, eName, eMode = "active"):
	var enemy = mulanFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.mode = eMode
	add_child(enemy)

func addMunroe(ePos, eName, eMode = "active"):
	var enemy = munroeFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.mode = eMode
	add_child(enemy)

func addAndronicus(ePos, eName, eMode = "active"):
	var enemy = andronicusFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.mode = eMode
	add_child(enemy)
	
func addMurphy(ePos, eName, eMode = "active"):
	var enemy = murphyFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.mode = eMode
	add_child(enemy)

func addTrenton(ePos, eName, eMode = "active"):
	var enemy = trentonFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.mode = eMode
	add_child(enemy)

func addAsimov(ePos, eName, eMode = "active"):
	var enemy = asimovFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.mode = eMode
	add_child(enemy)


#Add MCRN ships
func addMorrigan(ePos, eName, eMode = "active"):
	var ally = morriganFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.mode = eMode
	add_child(ally)

func addCorvette(ePos, eName, eMode = "active"):
	var ally = corvetteFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.mode = eMode
	add_child(ally)

func addRaptor(ePos, eName, eMode = "active"):
	var ally = raptorFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.mode = eMode
	add_child(ally)


func addScirocco(ePos, eName, eMode = "active"):
	var ally = sciroccoFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.mode = eMode
	add_child(ally)

func addDonnager(ePos, eName, eMode = "active"):
	var ally = donnagerFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.mode = eMode
	add_child(ally)
