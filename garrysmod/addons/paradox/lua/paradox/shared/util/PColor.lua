class.PColor {
    field.red("number", 255),
    field.green("number", 255),
    field.blue("number", 255),
    field.alpha("number", 255)
}

function PColor:GetGColor()
    return Color(self.red, self.green, self.blue, self.alpha)
end

function PColor:Multiply(amount, alphaAmount)
    alphaAmount = alphaAmount or 1
    return PColor:new(self.red * amount, self.green * amount, self.blue * amount, self.alpha * alphaAmount)
end