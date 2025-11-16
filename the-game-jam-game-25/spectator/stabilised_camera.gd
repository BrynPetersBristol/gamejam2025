extends Camera3D

@export var xr_camera : XRCamera3D
@export_range(0.01, 1.0, 0.01, "suffix:s") var smooth_delay : float = 0.1
var prev_transform : Transform3D = Transform3D()

# Called when the node enters the scene tree for the first time.
func _ready() :
	if xr_camera:
		prev_transform = xr_camera.transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not xr_camera:
		return
		
	var adjusted_transform : Transform3D = xr_camera.transform
	
	adjusted_transform.basis = Basis.looking_at(adjusted_transform.basis.z, Vector3.UP, true)
	
	adjusted_transform.basis = prev_transform.basis.slerp(adjusted_transform.basis, delta/smooth_delay)
	adjusted_transform.origin = prev_transform.origin.lerp(adjusted_transform.origin, delta/smooth_delay)
	
	global_transform = xr_camera.get_parent().global_transform * adjusted_transform
	
	prev_transform = adjusted_transform
