class.PVector {
    field.x("number"),
    field.y("number"),
    field.z("number")
}

function PVector:GetGVector()
    return Vector(self.x, self.y, self.z)
end