extends Spatial


var points:Array = [Vector3(0,0,0), Vector3(0,500,0)]
var geo:ImmediateGeometry
var draw:bool = false
var line_width:float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready():
    geo = ImmediateGeometry.new()
    add_child(geo)
    draw = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    geo.clear()
    if draw:
        geo.begin(2)
        for point in points:
            geo.add_vertex(point)
        geo.end()
