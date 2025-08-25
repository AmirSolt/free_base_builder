extends MeshInstance3D


@export var extra_padding:=2
@export var sub_mesh:MeshInstance3D

@export var grid_lines_mat:ShaderMaterial
@export var shadow_grid_lines_mat:ShaderMaterial

func _ready() -> void:
	assert(owner is Building)
	(owner as Building).update_requested.connect(_on_building_update)
	
	mesh=PlaneMesh.new()
	mesh.material=shadow_grid_lines_mat
	sub_mesh.mesh=PlaneMesh.new()
	sub_mesh.mesh.material=grid_lines_mat

func _on_building_update()->void:
	var size := (owner as Building).data.size
	var w:=(size.x+(extra_padding*2))*0.99
	var h:=(size.y+(extra_padding*2))*0.99
	mesh.size=Vector2(w,h)
	sub_mesh.mesh.size=Vector2(w,h)
	
