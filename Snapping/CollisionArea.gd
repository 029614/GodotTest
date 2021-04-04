class_name CollisionArea
extends Area


signal area_collision(subject, target)
signal area_decollide(subject,target)


# Called when the node enters the scene tree for the first time.
func _ready():
    self.connect("area_entered", self, "_on_area_entered")
    self.connect("area_exited",self,"_on_area_exited")


func _on_area_entered(area):
    emit_signal("area_collision", self, area)
    
func _on_area_exited(area):
    emit_signal("area_decollide", self, area)
