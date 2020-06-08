import "ItemRender"
import "PVector"
import "PAngle"

class.ItemRender {
    field.path("string"),
    field.posOffset(PVector, PVector:new(0, 0, 0)),
    field.angleOffset(PAngle, PAngle:new(0, 0, 0)),
    field.cameraPosOffset(PVector, PVector:new(0, 0, 0)),
    field.cameraAngleOffset(PAngle, PAngle:new(0, 0, 0))
}

ItemRender.OFFSETS = {
    ENTITY_POSITION = Vector(10, 8, -2),
    ENTITY_ANGLE = Angle(20, 225, 0),

    CAMERA_POSITION = Vector(-10, 0, 0),
    CAMERA_ANGLE = Angle(0, 0, 0)
}