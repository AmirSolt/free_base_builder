class_name MockBuilding extends Building


@export var highlights: Node3D
@export var mesh_instance:MeshInstance3D
@export var building_highlight:BuildingHighlight

func _ready() -> void:
	super._ready()
	highlights.hide()

func set_data(_data:BuildingData)->void:
	data=_data
	remove_child(mesh_instance)
	mesh_instance.queue_free()
	mesh_instance=data.mesh_scene.instantiate()
	add_child(mesh_instance)
	#mesh_instance.replace_by(new_mesh, true)
	building_highlight.mesh=mesh_instance
	update_requested.emit()
	#mesh_instance.position=_get_mock_building_mesh_pos(data)
#
#
#func _get_mock_building_mesh_pos(_data:BuildingData)->Vector3:
	#if _data.is_mesh_y_centered:
		#return Vector3(0, _data.mesh.get_aabb().size.y/2, 0)
	#return Vector3.ZERO
