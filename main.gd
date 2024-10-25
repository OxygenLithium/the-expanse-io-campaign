extends Node

var frigateFile = load("res://scenes/unn_frigate.tscn")
var cruiserFile = load("res://scenes/trenton_cruiser.tscn")

var UNNShips = []
var MCRNShips = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for i in range(3):
		#var enemy = frigateFile.instantiate()
		#enemy.position = Vector2(10000,-1000 + 1000*i)
		#add_child(enemy)
	
	var enemy = frigateFile.instantiate()
	enemy.position = Vector2(25000,-100)
	add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(36000,200)
	add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(-108000,-250)
	add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(15000,10000)
	add_child(enemy)
	
	enemy = frigateFile.instantiate()
	enemy.position = Vector2(17000,8000)
	add_child(enemy)
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
