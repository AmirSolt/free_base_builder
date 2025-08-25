class_name Building extends StaticBody3D

signal update_requested
signal component_call(params:Variant)

var data:BuildingData

static func build(building_parent:Node3D, pos:Vector3, _data:BuildingData)->Building:
	var building :Building= _data.building_scene.instantiate()
	building.data=_data
	building_parent.add_child(building)
	building.global_position=pos
	return building

func _ready() -> void:
	if data:
		update_requested.emit()

func remove()->void:
	queue_free()

## This is a special function to make x-ray selection possible by temporarily suspending input_ray_pickable for a frame. If there's a problem if x-ray click it's probably: await get_tree().process_frame. You might be able to change it to a timer instead. (Tried physics_frame didn't work.) 
func temp_ignore_input()->void:
	input_ray_pickable=false
	await get_tree().process_frame
	input_ray_pickable=true


static func get_size_offset(_data:BuildingData)->Vector3:
	var offset_x:float=float(_data.size.x-1)/2
	var offset_y:float=float(_data.size.y-1)/2
	return Vector3(offset_x, 0, -offset_y)
