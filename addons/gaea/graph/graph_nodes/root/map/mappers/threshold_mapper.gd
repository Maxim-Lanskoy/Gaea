@tool
extends GaeaNodeMapper
class_name GaeaNodeThresholdMapper
## Maps every cell of [param data] of a value in [param range] to [param material].


func _get_title() -> String:
	return "ThresholdMapper"


func _get_description() -> String:
	return "Maps every cell of [param]reference_data[/bg][/c] of a value in [param]range[/bg][/c] to [param]material[/bg][/c]."


func _get_arguments_list() -> Array[StringName]:
	return super() + ([&"range"] as Array[StringName])


func _get_argument_type(arg_name: StringName) -> GaeaValue.Type:
	match arg_name:
		&"range": return GaeaValue.Type.RANGE
	return super(arg_name)


func _passes_mapping(grid_data: Dictionary, cell: Vector3i, area: AABB, generator_data: GaeaData) -> bool:
	var range_value: Dictionary = _get_arg(&"range", area, generator_data)
	var cell_value = grid_data.get(cell)
	return cell_value >= range_value.get("min", 0.0) and cell_value <= range_value.get("max", 0.0)
