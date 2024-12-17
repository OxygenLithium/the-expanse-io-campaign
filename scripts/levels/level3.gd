extends "res://scripts/levels/abstract_level.gd"

func unn_ship_destroyed(ship):
	construct_mission_label()
	if UNNShips.size() < 1:
		victory()

func place_ships():
	addCorvette(Vector2(-1600,800), "MCRN Wukong")
	addCorvette(Vector2(-1600,-800), "UNN Nightwing")
	
	addMulan(Vector2(100000,0), "UNN Beirut")
	addAndronicus(Vector2(140000,700), "UNN Terence Moe")
	addMunroe(Vector2(140000,20000), "UNN Senden")
	addMunroe(Vector2(140000,-20000), "UNN Raiden")
	addMunroe(Vector2(148000,4000), "UNN Ursula Le Guin")
	addTrenton(Vector2(160000,4000), "UNN Stockholm")
	addTrenton(Vector2(160000,-4000), "UNN Salem")
