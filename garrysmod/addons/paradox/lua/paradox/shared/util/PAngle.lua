class.PAngle {
    field.pitch("number"),
    field.yaw("number"),
    field.roll("number")
}

function PAngle:GetGAngle()
    return Angle(self.pitch, self.yaw, self.roll)
end