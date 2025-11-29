extends GridMap

const WorldWidth = 200
const WorldHeight = 500
const WorldAmpli1 = 20
const WorldAmpli2 = 34

const WorldFractGain = 0.5
const WorldFractOct = 7
const WorldFractLac = 2.1
const WorldFreq = 0.01

const IslandSeed= 0

#destroy
func destroy_block(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)


func place_block(world_coordinate, block_index):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, block_index)

var DecoreFlowerOdds1: Array[int] = [11, 10, 10, 11, 8, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var DecoreTreeOdds1: Array[int] = [8, 9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var RandBlockRot1: Array[int] = [000, 330, 310, 010]


var rng = RandomNumberGenerator.new()
var noise := FastNoiseLite.new()
enum NoiseType{
	TYPE_VALUE = 5
}
	
var my_random_number = randf()


func _ready()->void: 
	noise.seed = IslandSeed
	noise.fractal_gain = WorldFractGain
	noise.fractal_octaves = WorldFractOct
	noise.fractal_lacunarity = WorldFractLac
	noise.frequency = WorldFreq
	

	for x in range(WorldWidth):
		for y in range(WorldHeight):
			for z in range(WorldWidth):
				if y < noise.get_noise_2d(x,z)*30+22: 	set_cell_item(Vector3i(x,y+2,z),DecoreTreeOdds1.pick_random(),RandBlockRot1.pick_random())
				#Tree placement, it needs to be higher up in func ready because it needs lesser priority
	for x in range(WorldWidth):
		for y in range(WorldHeight):
			for z in range(WorldWidth):
				if y < noise.get_noise_2d(x,z)*30+22: 	set_cell_item(Vector3i(x,y+2,z),DecoreFlowerOdds1.pick_random(),RandBlockRot1.pick_random())
	
	

	for x in range(WorldWidth):
		for y in range(WorldHeight):
			for z in range(WorldWidth):
				if y < noise.get_noise_2d(x,z)*30+22: 	set_cell_item(Vector3i(x,y+1,z),1,0) 
				#Grass placement, it needs to be higher up in func ready because it needs lesser priority
	for x in range(WorldWidth):
		for y in range(WorldHeight):
			for z in range(WorldWidth):
				if y < noise.get_noise_2d(x,z)*30+22: 	set_cell_item(Vector3i(x,y,z),0,0) #dirt placement
	
	for x in range(WorldWidth): 
		for y in range(11):
			for z in range(WorldWidth): set_cell_item(Vector3i(x,y,z),12,0)  #water placement
	for x in range(WorldWidth):
		for y in range(WorldHeight):
			for z in range(WorldWidth):
				if y < noise.get_noise_2d(x,z)*20+19: 	set_cell_item(Vector3i(x,y,z),7,0) #sand placement
	for x in range(WorldWidth):
		for y in range(WorldHeight):
			for z in range(WorldWidth):
				if y < noise.get_noise_2d(x,z)*WorldAmpli2++WorldAmpli1: 	set_cell_item(Vector3i(x,y+1,z),2,0)  #stone placement
	for x in range(WorldWidth): 
		for y in range(1):
			for z in range(WorldWidth): set_cell_item(Vector3i(x,y,z),6,0)  #bedrock placement
