hColor = {
    mixed = function(str, color)
        return "|cff" .. color .. str .. "|r"
    end
};

hColor.gold = function(str)
    return hColor.mixed(str, "ffcc00")
end

hColor.white = function(str)
    return hColor.mixed(str, "ffffff")
end

hColor.redLight = function(str)
    return hColor.mixed(str, "ff8080")
end

hColor.red = function(str)
    return hColor.mixed(str, "ff3939")
end

hColor.greenLight = function(str)
    return hColor.mixed(str, "ccffcc")
end

hColor.green = function(str)
    return hColor.mixed(str, "80ff00")
end

hColor.yellowLight = function(str)
    return hColor.mixed(str, "ffffcc")
end

hColor.yellow = function(str)
    return hColor.mixed(str, "ffff00")
end

hColor.skyLight = function(str)
    return hColor.mixed(str, "ccffff")
end

hColor.sky = function(str)
    return hColor.mixed(str, "80ffff")
end

hColor.seaLight = function(str)
    return hColor.mixed(str, "99ccff")
end

hColor.sea = function(str)
    return hColor.mixed(str, "00ccff")
end

hColor.purpleLight = function(str)
    return hColor.mixed(str, "99ff70")
end

hColor.purple = function(str)
    return hColor.mixed(str, "ff59ff")
end

