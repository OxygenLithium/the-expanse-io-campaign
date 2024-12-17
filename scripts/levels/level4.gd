extends "res://scripts/levels/abstract_level.gd"

func unn_ship_destroyed(ship):
	construct_mission_label()
	if UNNShips.size() < 1:
		victory()

func place_ships():
	addCorvette(Vector2(-1600,800), "MCRN Wukong")
	addCorvette(Vector2(-1600,-800), "UNN Nightwing")
	addScirocco(Vector2(-3200,0), "UNN Monsoon")
	
	addMulan(Vector2(108000,6000), "UNN Milton")
	addMulan(Vector2(10600,0), "UNN Jasper")
	addMulan(Vector2(108000,-6000), "UNN Beirut")
	addMunroe(Vector2(140000,-6000), "UNN St. Elmo's Fire")
	addMunroe(Vector2(140000, 6000), "UNN Maracaibo")
	
	addAndronicus(Vector2(180000,0), "UNN Maracaibo")
	addAndronicus(Vector2(180000,0), "UNN Hou Yi")
	
	addTrenton(Vector2(200000,6000), "UNN Katyusha")
	addTrenton(Vector2(200000,-6000), "UNN Chelyabinsk")
