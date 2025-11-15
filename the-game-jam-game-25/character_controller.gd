@tool
class_name XRCharacterController
extends XROrigin3D

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
	var character_body : CharacterBody3D = get_parent()
	if not character_body:
		return
		
	var camera : XRCamera3D = get_node_or_null("XRCamera3D")
	if not camera:
		return
