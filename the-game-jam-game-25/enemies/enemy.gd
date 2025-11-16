extends CharacterBody3D

@export_range(0.1, 1.0, 0.1, "suffix:s") var speed : float = 0.1
@export_range(1.0, 3.0, 0.1, "suffix:s") var height : float = 1.7

@onready var player = get_parent().get_parent().get_node("Player")
var reached_player = false
var collision = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var rotation_transform = transform.looking_at(Vector3(player.global_transform.x, 1.7, player.global_transform.z), Vector3.UP, false)
	#transform.basis = rotation_transform.basis * transform.basis
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	transform.origin.y = height/2
	var vec_to_player = Vector3(player.global_position.x - global_position.x, 0.0, player.global_position.z - global_position.z)
	var velocity = vec_to_player.normalized() * speed
	print(reached_player)
	print(player.global_position)
	print(global_position)
	if not reached_player:
		#var velocity = Vector3(min(player.transform.origin.x - transform.origin.x, speed), 0.0, min(player.transform.origin.z - transform.origin.z, speed))
		collision = move_and_collide(velocity)
		#print(velocity)
		print(abs(global_position.x))
		#print(abs(transform.origin.x - player.transform.origin.x) < 0.1)
		if abs(global_position.x) < 0.15 and abs(global_position.z) < 0.15:
			reached_player = true
	else:
		collision = move_and_collide(Vector3(speed, 0.0, speed))
		
		if (abs(player.transform.origin.x - transform.origin.x) > 3) or (abs(player.transform.origin.z - transform.origin.z) > 3):
			get_parent().queue_free()
			
	if collision:
		player.get_node("ImpactSound").play()
		player.get_node("ScreamSound").play()
		player.get_node("Audio").play()
		get_parent().queue_free()
		#print("Ouch")
		
	
	
	## create a rotation transform
	#var rotation_transform = transform.looking_at(Vector3(player.global_transform.x, 1.7, player.global_transform.z), Vector3.UP, false)
	#
	## apply this rotation to body
	#transform.basis = rotation_transform.basis * transform.basis
	#
	##var direction = (player.position - position).normalised()
	#var velocity = transform.basis * speed
	#move_and_slide()
