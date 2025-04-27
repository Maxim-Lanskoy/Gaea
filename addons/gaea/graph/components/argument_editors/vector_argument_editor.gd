@tool
extends GaeaGraphNodeArgumentEditor
class_name GaeaVector3ArgumentEditor


@onready var _x_spin_box: SpinBox = $XSpinBox
@onready var _y_spin_box: SpinBox = $YSpinBox
@onready var _z_spin_box: SpinBox = $ZSpinBox


func _configure() -> void:
	if is_part_of_edited_scene():
		return
	await super()
	_x_spin_box.value_changed.connect(argument_value_changed.emit)
	_y_spin_box.value_changed.connect(argument_value_changed.emit)
	_z_spin_box.value_changed.connect(argument_value_changed.emit)

	if type == GaeaValue.Type.VECTOR2I or type == GaeaValue.Type.VECTOR3I:
		_x_spin_box.step = 1
		_y_spin_box.step = 1
		_z_spin_box.step = 1

	if type == GaeaValue.Type.VECTOR2 or type == GaeaValue.Type.VECTOR2I:
		_z_spin_box.set_visible.call_deferred(false)
		graph_node.auto_shrink.call_deferred()

	if hint.has("min"):
		_x_spin_box.min_value = hint.get("min").x
		_y_spin_box.min_value = hint.get("min").y
		if type == GaeaValue.Type.VECTOR3 or type == GaeaValue.Type.VECTOR3I:
			_z_spin_box.min_value = hint.get("min").z

	if hint.has("max"):
		_x_spin_box.min_value = hint.get("max").x
		_y_spin_box.min_value = hint.get("max").y
		if type == GaeaValue.Type.VECTOR3 or type == GaeaValue.Type.VECTOR3I:
			_z_spin_box.min_value = hint.get("max").z

	_x_spin_box.allow_lesser = not hint.has("min")
	_y_spin_box.allow_lesser = not hint.has("min")
	_z_spin_box.allow_lesser = not hint.has("min")
	_x_spin_box.allow_greater = not hint.has("max")
	_y_spin_box.allow_greater = not hint.has("max")
	_z_spin_box.allow_greater = not hint.has("max")



func get_arg_value() -> Variant:
	if super() != null:
		return super()
	match type:
		GaeaValue.Type.VECTOR2:
			return Vector2(_x_spin_box.value, _y_spin_box.value)
		GaeaValue.Type.VECTOR2I:
			return Vector2i(int(_x_spin_box.value), int(_y_spin_box.value))
		GaeaValue.Type.VECTOR3:
			return Vector3(_x_spin_box.value, _y_spin_box.value, _z_spin_box.value)
		GaeaValue.Type.VECTOR3I:
			return Vector3i(int(_x_spin_box.value), int(_y_spin_box.value), int(_z_spin_box.value))
	return null


func set_arg_value(new_value: Variant) -> void:
	var new_value_type = typeof(new_value)
	if not typeof(new_value) in [
		GaeaValue.Type.VECTOR2,
		GaeaValue.Type.VECTOR2I,
		GaeaValue.Type.VECTOR3,
		GaeaValue.Type.VECTOR3I
	]:
		return

	_x_spin_box.value = float(new_value.x)
	_y_spin_box.value = float(new_value.y)
	if new_value_type == GaeaValue.Type.VECTOR3 or new_value_type == GaeaValue.Type.VECTOR3I:
		_z_spin_box.value = float(new_value.z)
	else:
		_z_spin_box.value = 0.0
