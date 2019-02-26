hrectData = {}
hrect = {
    --创建一个设定中心（x,y）创建一个长w宽h的矩形区域
    create = function(x, y, w, h, name)
        local startX = x - (w * 0.5)
        local startY = y - (h * 0.5)
        local endX = x + (w * 0.5)
        local endY = y + (h * 0.5)
        local r = cj.Rect(startX, startY, endX, endY)
        hrectData[r] = {
            name = name,
            x = x,
            y = y,
            width = w,
            height = h,
            startX = startX,
            startY = startY,
            endX = endX,
            endY = endY,
        }
        return r
    end,
    --创建一个设定点（loc）创建一个长w宽h的矩形区域
    createAtLoc = function(loc, w, h, name)
        return hrect.create(cj.GetLocationX(loc), cj.GetLocationY(loc), w, h, name)
    end,
    --获取数据
    getName = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].name
        end
        return nil
    end,
    getX = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].x
        end
        return nil
    end,
    getY = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].y
        end
        return nil
    end,
    getWidth = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].width
        end
        return nil
    end,
    getHeight = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].height
        end
        return nil
    end,
    getStartX = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].startX
        end
        return nil
    end,
    getStartY = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].startY
        end
        return nil
    end,
    getEndX = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].endX
        end
        return nil
    end,
    getEndY = function(whichRect)
        if (hrectData[whichRect]) then
            return hrectData[whichRect].endY
        end
        return nil
    end,
    --删除区域
    del = function(whichRect, during)
        if (during > 0) then
            htime.setTimeout(during, nil, function(t, td)
                htime.delTimer(t)
                htime.delDialog(td)
                cj.RemoveRect(whichRect)
            end)
        else
            cj.RemoveRect(whichRect)
        end
    end,
    --区域单位锁定
    --[[
        {
            type 类型有：square|circle // 矩形(默)|圆形
            during 持续时间 必须大于0
            width 锁定活动范围长，大于0
            height 锁定活动范围宽，大于0
            whichRect 锁定区域时设置，可选
            whichUnit 锁定某个单位时设置，可选
            whichLoc 锁定某个点时设置，可选
            whichX 锁定某个坐标X时设置，可选
            whichY 锁定某个坐标Y时设置，可选
        }
    ]]
    lock = function(bean)
        if (bean.during <= 0 or (bean.whichRect == nil and (bean.width <= 0 or bean.height <= 0))) then
            return
        end
        if (bean.whichRect == nil and whichUnit == nil and whichLoc == nil and (whichX == nil or whichY == nil)) then
            return
        end
        if (bean.type == nil) then
            bean.type = 'square'
        end
        if (bean.type ~= "square" and bean.type ~= "circle") then
            return
        end
        local inc = 0
        local inGroups = {}
        htime.setInterval(0.10, nil, function(t, td)
            inc = inc + 1
            if (inc > (during / 0.10)) then
                htime.delDialog(td)
                htime.delTimer(t)
                return
            end
            local x = bean.whichX
            local y = bean.whichY
            local w = bean.width
            local h = bean.height
            --点优先
            if (bean.whichLoc) then
                x = cj.GetLocationX(bean.whichLoc)
                y = cj.GetLocationY(bean.whichLoc)
            end
            --单位优先
            if (bean.whichUnit) then
                if (his.death(bean.whichUnit)) then
                    htime.delDialog(td)
                    htime.delTimer(t)
                    return
                end
                x = cj.GetUnitX(bean.whichUnit)
                y = cj.GetUnitY(bean.whichUnit)
            end
            --区域优先
            if (bean.whichRect) then
                x = cj.GetRectCenter(bean.whichRect)
                y = cj.GetRectCenter(bean.whichRect)
                if (hrect.getWidth(bean.whichRect) < w) then
                    w = hrect.getWidth(bean.whichRect)
                end
                if (hrect.getHeight(bean.whichRect) < h) then
                    h = hrect.getHeight(bean.whichRect)
                end
            end
            local lockDegA = (180 * cj.Atan(h / w)) / bj_PI
            local lockDegB = 90 - lockDegA
            local lockRect
            local lockGroup
            if (bean.type == "square") then
                lockRect = cj.Rect(x - (w * 0.5), y - (h * 0.5), x + (w * 0.5), y + (h * 0.5))
                lockGroup = cj.CreateGroup()
                cj.GroupEnumUnitsInRect(lockGroup. lockRect, nil)
            elseif (bean.type == "circle") then
                local rectCenter = cj.Location(x, y)
                lockGroup = cj.CreateGroup()
                cj.GroupEnumUnitsInRangeOfLoc(lockGroup, rectCenter, math.min(w / 2, h / 2), nil)
                cj.removeLocation(rectCenter)
            end
            if (lockGroup ~= nil) then
                while (cj.IsUnitGroupEmptyBJ(lockGroup) == false) do
                    local u = cj.FirstOfGroup(lockGroup)
                    cj.GroupRemoveUnit(lockGroup, u)
                    if (~hsystem.inArray(u, inGroups)) then
                        table.insert(inGroups, u)
                    end
                end
                cj.GroupClear(lockGroup)
                cj.DestroyGroup(lockGroup)
            end
            --锁
            for k, u in pairs(inGroups) do
                local distance = 0.000
                local deg = 0
                local xx = cj.GetUnitX(u)
                local yy = cj.GetUnitY(u)
                if (bean.type == "square") then
                    if (his.borderRect(lockRect, xx, yy) == true) then
                        deg = hlogic.getDegBetweenXY(x, y, xx, yy)
                        if (deg == 0 or deg == 180 or deg == -180) then
                            -- 横
                            distance = w
                        elseif (deg == 90 or deg == -90) then
                            -- 竖
                            distance = h
                        elseif (deg > 0 and deg <= lockDegA) then
                            -- 第1三角区间
                            distance = w / 2 / math.cos(deg * bj_DEGTORAD)
                        elseif (deg > lockDegA and deg < 90) then
                            -- 第2三角区间
                            distance = h / 2 / math.cos(90 - deg * bj_DEGTORAD)
                        elseif (deg > 90 and deg <= 90 + lockDegB) then
                            -- 第3三角区间
                            distance = h / 2 / math.cos((deg - 90) * bj_DEGTORAD)
                        elseif (deg > 90 + lockDegB and deg < 180) then
                            -- 第4三角区间
                            distance = w / 2 / math.cos((180 - deg) * bj_DEGTORAD)
                        elseif (deg < 0 and deg >= -lockDegA) then
                            -- 第5三角区间
                            distance = w / 2 / math.cos(deg * bj_DEGTORAD)
                        elseif (deg < lockDegA and deg > -90) then
                            -- 第6三角区间
                            distance = h / 2 / math.cos((90 + deg) * bj_DEGTORAD)
                        elseif (deg < -90 and deg >= -90 - lockDegB) then
                            -- 第7三角区间
                            distance = h / 2 / math.cos((-deg - 90) * bj_DEGTORAD)
                        elseif (deg < -90 - lockDegB and deg > -180) then
                            -- 第8三角区间
                            distance = w / 2 / math.cos((180 + deg) * bj_DEGTORAD)
                        end
                    end
                elseif (bean.type == "circle") then
                    if (hlogic.getDistanceBetweenXY(x, y, xx, yy) > math.min(w / 2, h / 2)) then
                        deg = hlogic.getDegBetweenXY(x, y, xx, yy)
                        distance = math.min(w / 2, h / 2)
                    end
                end
                if (distance > 0.0) then
                    local polar = hlogic.polarProjection(x, y, distance, deg)
                    local loc = cj.Location(polar.x, polar.y)
                    cj.SetUnitPositionLoc(u, loc)
                    cj.RemoveLocation(loc)
                    heffect.toUnit("Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl", u, "origin", 0.2)
                    hmsg.style(hmsg.ttg2Unit(u, "被困", 10, "dde6f3", 30, 1, 20), "shrink", 0, 0.2)
                end
            end
            if (lockRect ~= nil) then
                cj.RemoveRect(lockRect)
            end
        end)
    end,
}