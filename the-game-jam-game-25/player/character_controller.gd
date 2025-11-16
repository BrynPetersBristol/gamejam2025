@tool
class_name XRCharacterController
extends XROrigin3D

@export_range(0.1, 10.0, 0.01, "suffix:s") var gravity : float = 1.0

func _get_configuration_warnings():
	var warnings : PackedStringArray
	
	var parent = get_parent()
	if not parent or not parent is CharacterBody3D:
		warnings.push_back("This node must be a child of a CharacterBody3D")
		
	var camera = get_node_or_null("XRCamera3D")
	if not camera or not camera is XRCamera3D:
			warnings.push_back("This node must have an XRCamera3D child")
		
	return warnings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Engine.is_editor_hint():
		return
		
	var character_body : CharacterBody3D = get_parent()
	if not character_body:
		return
		
	var camera : XRCamera3D = get_node_or_null("XRCamera3D")
	if not camera:
		return
	
	 # determines camera transform in relation to character body (local)
	var camera_transform = transform * camera.transform
	
	# determines new position
	var new_position : Vector3 = camera_transform.origin * Vector3(1.0, 0.0, 1.0)
	
	# get this position in world space
	new_position = character_body.global_transform * new_position
	
	# move character body
	var original_position = character_body.global_position
	character_body.move_and_collide(new_position - original_position)
	
	# check movement
	var delta_movement = character_body.global_position - original_position
	
	delta_movement = character_body.global_basis.inverse() * delta_movement
	
	# move origin in opposite direction
	position -= delta_movement 
	
	 # determine forward vector
	var forward = camera_transform.basis.z * Vector3(1.0, 0.0, 1.0)
	
	# create a rotation transform
	camera_transform.origin = Vector3()
	var rotation_transform = camera_transform.looking_at(forward, Vector3.UP, true)
	
	# apply this rotation to character body
	character_body.transform.basis = rotation_transform.basis * character_body.transform.basis
	
	# apply inverse to origin
	transform = rotation_transform.inverse() * transform
	
	var distance_from_ground = (camera.position.y + 0.3) / 2
	character_body.scale.y = distance_from_ground
	character_body.global_position.y = distance_from_ground
