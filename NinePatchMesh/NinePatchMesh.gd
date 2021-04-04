extends Spatial
class_name NinePatchMesh

enum corner {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}
var corners

var column_left
var column_middle
var column_right

var row_top
var row_middle
var row_bottom

var size:Vector3 setget set_size
var left_position:float = 0.0 setget set_left_position
var right_position:float = size.x setget set_right_position
var top_position:float = 0.0 setget set_top_position
var bottom_position:float = size.y setget set_bottom_position


# Called when the node enters the scene tree for the first time.
func _ready():
    var one = MeshInstance.new()
    one.mesh = CubeMesh.new()
    var two = MeshInstance.new()
    two.mesh = CubeMesh.new()
    var three = MeshInstance.new()
    three.mesh = CubeMesh.new()
    var four = MeshInstance.new()
    four.mesh = CubeMesh.new()
    var five = MeshInstance.new()
    five.mesh = CubeMesh.new()
    var six = MeshInstance.new()
    six.mesh = CubeMesh.new()
    var seven = MeshInstance.new()
    seven.mesh = CubeMesh.new()
    var eight = MeshInstance.new()
    eight.mesh = CubeMesh.new()
    var nine = MeshInstance.new()
    nine.mesh = CubeMesh.new()
    
    add_child(one)
    add_child(two)
    add_child(three)
    add_child(four)
    add_child(five)
    add_child(six)
    add_child(seven)
    add_child(eight)
    add_child(nine)
    
    corners = [one, three, seven, nine]
    
    column_left = [one, four, seven]
    column_middle = [two, five, eight]
    column_right = [three, six, nine]
    
    row_top = [one, two, three]
    row_middle = [four, five, six]
    row_bottom = [seven, eight, nine]


func set_left_position(value:float):
    left_position = value


func set_right_position(value:float):
    right_position = value


func set_top_position(value:float):
    top_position = value


func set_bottom_position(value:float):
    bottom_position = value


func set_size(value:Vector3):
    size = value
    
