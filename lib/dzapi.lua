hdzapi = {}
hdzapi.hdz_map_lv = 10001

-- 是否红V
hdzapi.isVipRed = function(whichPlayer)
    return japi.DzAPI_Map_IsRedVIP(whichPlayer)
end

-- 是否蓝V
hdzapi.isVipBlue = function(whichPlayer)
    return japi.DzAPI_Map_IsBlueVIP(whichPlayer)
end

-- 获取地图等级
hdzapi.mapLv = function(whichPlayer)
    return japi.DzAPI_Map_GetMapLevel(whichPlayer)
end

-- 是否有商城道具
hdzapi.hasMallItem = function(whichPlayer, key)
    return japi.DzAPI_Map_HasMallItem(whichPlayer, key)
end

-- 服务器存档
hdzapi.server = {}
-- save / load
hdzapi.server.save = function(whichPlayer, key, data)
    japi.DzAPI_Map_SaveServerValue(whichPlayer, key, data)
end
hdzapi.server.load = function(whichPlayer, key, data)
    return japi.DzAPI_Map_GetServerValue(whichPlayer, key)
end
-- 封装的服务器存档 get / set
hdzapi.server.set = {
    int = function(whichPlayer, key, data)
        japi.DzAPI_Map_SaveServerValue(whichPlayer, 'I' .. key, data or 0)
    end,
    real = function(whichPlayer, key, data)
        japi.DzAPI_Map_SaveServerValue(whichPlayer, 'R' .. key, data or 0)
    end,
    bool = function(whichPlayer, key, data)
        local b = '0'
        if (data == true) then
            b = '1'
        end
        japi.DzAPI_Map_SaveServerValue(whichPlayer, 'B' .. key, data or 0)
    end,
    str = function(whichPlayer, key, data)
        japi.DzAPI_Map_SaveServerValue(whichPlayer, 'S' .. key, data or nil)
    end,
    unit = function(whichPlayer, key, data)
        local id = hSys.getObjChar(cj.GetUnitTypeId(data))
        japi.DzAPI_Map_SaveServerValue(whichPlayer, 'S' .. key, id, data or nil)
    end,
    item = function(whichPlayer, key, data)
        local id = hSys.getObjChar(cj.GetItemTypeId(data))
        japi.DzAPI_Map_SaveServerValue(whichPlayer, 'S' .. key, id, data or nil)
    end,
}
hdzapi.server.get = {
    int = function(whichPlayer, key)
        return japi.DzAPI_Map_GetServerValue(whichPlayer, 'I' .. key) or 0
    end,
    real = function(whichPlayer, key)
        return japi.DzAPI_Map_GetServerValue(whichPlayer, 'R' .. key) or 0
    end,
    bool = function(whichPlayer, key)
        local b = japi.DzAPI_Map_GetServerValue(whichPlayer, 'B' .. key)
        if (b == '1') then
            return true
        end
        return false
    end,
    str = function(whichPlayer, key)
        return japi.DzAPI_Map_GetServerValue(whichPlayer, 'S' .. key) or ''
    end,
    unit = function(whichPlayer, key)
        local id = japi.DzAPI_Map_GetServerValue(whichPlayer, 'S' .. key) or ''
        if (string.len(id) > 0) then
            return hSys.getObjId(id)
        end
        return nil
    end,
    item = function(whichPlayer, key)
        local id = japi.DzAPI_Map_GetServerValue(whichPlayer, 'S' .. key) or ''
        if (string.len(id) > 0) then
            return hSys.getObjId(id)
        end
        return nil
    end,
}
-- 清理服务器数据
hdzapi.server.clear = function(whichPlayer, key)
    japi.DzAPI_Map_SaveServerValue(whichPlayer, key, nil)
end

return hdzapi
