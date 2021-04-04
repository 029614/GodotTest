extends StaticBody


var width:float = 10.0
var depth:float = 2.5
var height:float = 10.0
var type:String = "wall"

var wall_plane:Plane


# Called when the node enters the scene tree for the first time.
func _ready():
    wall_plane = Plane(translation + Vector3(width*.5, height*.5, 0),translation + Vector3(width*.5, -height*.5, 0),translation + Vector3(-width*.5, -height*.5, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
