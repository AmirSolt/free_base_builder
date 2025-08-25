class_name BuildingData extends Resource


@export var icon:Texture2D
@export var display_name:String
@export var description:String

@export var mesh_scene:PackedScene
@export var building_scene:PackedScene

## Size refers to the amount of space a building takes in cells. You should try to match this with the size of the building mesh.
@export var size:=Vector2i(1,1)
@export var range:int=0
@export_flags_2d_physics var surface_collision_layer:int=2
