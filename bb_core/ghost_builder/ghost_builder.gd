class_name GhostBuilder extends Area3D

enum State{
	CLOSED,
	PLACEABLE,
	UNPLACEABLE,
}


@export_group("Level Vars")
@export var grid_map:GridMap
@export var grid_floor:=1
@export var building_container:Node
## Created building will be added to this node.  
@export var view_camera:Camera3D

@export_group("Internal Vars")
@export var mock_building:MockBuilding
@export var base_collision:CollisionShape3D
@export_group("Internal (Leave Empty)")
@export var state:State
@export var building_data:BuildingData
var plane:Plane

func open(_data:BuildingData)->void:
	building_data=_data
	state=State.UNPLACEABLE
	mock_building.set_data(_data)
	base_collision.shape.size=Vector3(_data.size.x, 1, _data.size.y)
	process_mode=PROCESS_MODE_ALWAYS
	
#	We want to show the node after it's position has been calculated
	#show()

func close()->void:
	state=State.CLOSED
	process_mode=PROCESS_MODE_DISABLED
	mock_building.highlights.hide()
	hide()


func _ready() -> void:
	close()
#	Only change lines below, if you know what you're doing.
	plane=Plane(Vector3.UP, Vector3(0, grid_map.cell_size.y*grid_floor, 0))
	base_collision.scale=Vector3(0.9, 2, 0.9)
#	=========================================

func _input(event: InputEvent) -> void:
	if state==State.CLOSED:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		close()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		close()
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos:=_get_grid_pos_by_mouse()
		var coords:=grid_map.local_to_map(pos)
		var cell_pos:=grid_map.map_to_local(coords)+Building.get_size_offset(building_data)
		_update_collision_pos(building_data, cell_pos)
		if await get_state()==State.PLACEABLE:
			Building.build(building_container, cell_pos, building_data)
			close()
		event.set_meta("is_used",true)
		get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
	if state==State.CLOSED:
		return
	var pos:=_get_grid_pos_by_mouse()
	var coords:=grid_map.local_to_map(pos)
	var cell_pos:=grid_map.map_to_local(coords)+Building.get_size_offset(building_data)
	_update_collision_pos(building_data, cell_pos)
	match await get_state():
		State.PLACEABLE:
			global_position=cell_pos
			mock_building.component_call.emit(BuildingHighlight.BuildingHighlightParam.new(true, Color(0,1,0,0.4)))
			mock_building.highlights.show()
		State.UNPLACEABLE:
			global_position=pos+Building.get_size_offset(building_data)
			mock_building.component_call.emit(BuildingHighlight.BuildingHighlightParam.new(true, Color(1,0,0,0.3)))
			mock_building.highlights.hide()
	if !visible and state!=State.CLOSED:
		show()

func is_open()->bool:
	return state!=State.CLOSED

func get_state()->State:
#	The only collision we're looking for is floor.
	await get_tree().physics_frame
	if get_overlapping_bodies().size()!=1:
		return State.UNPLACEABLE
	if !(get_overlapping_bodies()[0] as PhysicsBody3D).get_collision_layer_value(building_data.surface_collision_layer):
		return State.UNPLACEABLE
	return State.PLACEABLE

func _get_grid_pos_by_mouse()->Vector3:
	var world_position = plane.intersects_ray(
		view_camera.project_ray_origin(get_viewport().get_mouse_position()),
		view_camera.project_ray_normal(get_viewport().get_mouse_position()))
	var gridmap_position := Vector3(world_position.x, grid_map.cell_size.y*grid_floor, world_position.z)
	return gridmap_position



func _update_collision_pos(_data:BuildingData, _cell_pos:Vector3)->void:
	base_collision.global_position=Vector3(_cell_pos.x, _cell_pos.y, _cell_pos.z)
