local hgroup = {}

-- 统计单位组当前单位数
hgroup.count = function(whichGroup)
    if (whichGroup == nil) then
        return 0
    end
    return cj.CountUnitsInGroup(whichGroup)
end

-- 判断单位是否在单位组内
hgroup.isIn = function(whichGroup, whichUnit)
    if (whichGroup == nil) then
        return false
    end
    return cj.IsUnitInGroup(whichUnit, whichGroup)
end
-- 判断单位组是否为空
hgroup.isEmpty = function(whichGroup)
    if (whichGroup == nil) then
        return true
    end
    local isUnitGroupEmptyResult = true
    cj.ForGroup(whichGroup, function()
        isUnitGroupEmptyResult = false
    end)
    return isUnitGroupEmptyResult
end

-- 单位组添加单位
hgroup.addUnit = function(whichGroup, whichUnit)
    if (hgroup.isIn(whichGroup, whichUnit) == false) then
        cj.GroupAddUnit(whichGroup, whichUnit)
    end
end
-- 单位组删除单位
hgroup.removeUnit = function(whichGroup, whichUnit)
    if (hgroup.isIn(whichGroup, whichUnit) == true) then
        cj.GroupRemoveUnit(whichGroup, whichUnit)
    end
end

-- 创建单位组,以loc点为中心radius距离
hgroup.createByLoc = function(loc, radius, filterFunc)
    -- 镜头放大模式下，范围缩小一半
    if (hcamera.model == "zoomin") then
        radius = radius * 0.5
    end
    local bx = cj.Condition(filterFunc)
    local g = cj.CreateGroup()
    cj.GroupEnumUnitsInRangeOfLoc(g, loc, radius, bx)
    cj.DestroyBoolExpr(bx)
    return g
end

-- 创建单位组,以某个单位为中心radius距离
hgroup.createByUnit = function(u, radius, filterFunc)
    local loc = cj.GetUnitLoc(u)
    local g = hgroup.createByLoc(loc, radius, filterFunc)
    cj.RemoveLocation(loc)
    return g
end

-- 创建单位组,以区域为范围选择
hgroup.createByRect = function(r, filterFunc)
    local bx = cj.Condition(filterFunc)
    local g = cj.CreateGroup()
    cj.GroupEnumUnitsInRect(g, r, bx)
    cj.DestroyBoolExpr(bx)
    return g
end

-- 瞬间移动单位组
hgroup.move = function(whichGroup, loc, eff, isFollow)
    if (whichGroup == nil or loc == nil) then
        return
    end
    local g = cj.CreateGroup()
    cj.GroupAddGroup(g, whichGroup)
    while (cj.IsUnitGroupEmptyBJ(g) ~= true) do
        local u = cj.FirstOfGroup(g)
        cj.GroupRemoveUnit(g, u)
        cj.SetUnitPositionLoc(u, loc)
        if (isFollow == true) then
            cj.PanCameraToTimedLocForPlayer(cj.GetOwningPlayer(u), loc, 0.00)
        end
        if (eff ~= null) then
            heffect.toLoc(eff, loc, 0)
        end
    end
    cj.GroupClear(g)
    cj.DestroyGroup(g)
end

-- 指挥单位组所有单位做动作
-- string animateStr
hgroup.animate = function(whichGroup, animateStr)
    if (whichGroup == nil or animateStr == nil) then
        return
    end
    local g = cj.CreateGroup()
    cj.GroupAddGroup(g, whichGroup)
    while (cj.IsUnitGroupEmptyBJ(g) ~= true) do
        local u = cj.FirstOfGroup(g)
        cj.GroupRemoveUnit(g, u)
        if (his.death(u) == false) then
            cj.SetUnitAnimation(u, animateStr)
        end
    end
    cj.GroupClear(g)
    cj.DestroyGroup(g)
end

-- 清空单位组
-- isDestroy 是否同时删除单位组
-- isDestroyUnit 是否同时删除单位组里面的单位
hgroup.clear = function(whichGroup, isDestroy, isDestroyUnit)
    if (whichGroup == nil) then
        return
    end
    local g = cj.CreateGroup()
    cj.GroupAddGroup(g, whichGroup)
    while (cj.IsUnitGroupEmptyBJ(g) ~= true) do
        local u = cj.FirstOfGroup(g)
        cj.GroupRemoveUnit(g, u)
        if (isDestroyUnit == true) then
            cj.RemoveUnit(u)
        end
    end
    if (isDestroy == true) then
        cj.DestroyGroup(g)
    end
end

return hgroup