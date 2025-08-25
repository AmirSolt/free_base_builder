extends MeshInstance3D

@export var mesh_material:StandardMaterial3D

func _ready() -> void:
	assert(owner is Building)
	(owner as Building).update_requested.connect(_on_building_update)
	mesh=PlaneMesh.new()
	mesh.material=mesh_material

func _on_building_update()->void:
	var size := (owner as Building).data.size
	(mesh as PlaneMesh).size=size
	
