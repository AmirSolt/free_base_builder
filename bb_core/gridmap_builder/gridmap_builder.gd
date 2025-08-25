@tool
extends GridMap

@export var buildings:Array[BuildingData]=[]
@export var building_container:Node

## Editor only variable
var _buildings_hash:int

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	hide()
	for inx in buildings.size():
		for coords in get_used_cells_by_item(inx):
			_build(coords, buildings[inx])

func _update_buildings_mesh_lib() -> void:
	mesh_library.clear()
	for building_data in buildings:
		var mesh_node:MeshInstance3D=building_data.mesh_scene.instantiate()
		var id:=mesh_library.get_last_unused_item_id()
		mesh_library.create_item(id)
		mesh_library.set_item_mesh(id, mesh_node.mesh)
		mesh_node.transform.origin+=Building.get_size_offset(building_data)
		mesh_library.set_item_mesh_transform(id, mesh_node.transform)
		mesh_library.set_item_name(id, building_data.display_name)
		mesh_library.set_item_preview(id, building_data.icon)
		mesh_node.queue_free()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		buildings.hash()
		if buildings.hash()!=_buildings_hash:
			_buildings_hash = buildings.hash()
			_update_buildings_mesh_lib()

func _build(coords:Vector3i, building_data:BuildingData)->void:
	var cell_pos:=map_to_local(coords)+Building.get_size_offset(building_data)
	Building.build(building_container, cell_pos, building_data)
