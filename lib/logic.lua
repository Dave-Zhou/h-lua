hlogic = {

    -- 计算字符串宽度
    stringLen = function(str)
        local lenInByte = #str
        local fontSize = 20
        local width = 0
        for i = 1, lenInByte do
            local curByte = string.byte(str, i)
            local byteCount = 1;
            if curByte > 0 and curByte <= 127 then
                byteCount = 1
            elseif curByte >= 192 and curByte < 223 then
                byteCount = 2
            elseif curByte >= 224 and curByte < 239 then
                byteCount = 3
            elseif curByte >= 240 and curByte <= 247 then
                byteCount = 4
            end
            i = i + byteCount - 1
            if byteCount == 1 then
                width = width + fontSize * 0.5
            else
                width = width + fontSize
            end
        end
        return width
    end,

    --极坐标位移
    polarProjection = function(x, y, dist, angle)
        return {
            x = x + dist * math.cos(angle * bj_DEGTORAD),
            y = y + dist * math.sin(angle * bj_DEGTORAD),
        }
    end,

    --获取物品几率叠加几率
    --根据固定因子及增益因子计算几率因子
    oddsItem = function(odds_stable, odds_gain, timers)
        return odds_stable + odds_stable * ((timers - 1) * odds_gain)
    end,

    --计算属性特效效果叠加
    coverAttrEffectVal = function(value1, value2)
        if (math.abs(value1) > math.abs(value2)) then
            return value2 * 0.15 + value1
        else
            return value1 * 0.15 + value2
        end
    end,

    -- 四舍五入
    round = function(decimal)
        return math.floor((decimal * 100) + 0.5) * 0.01
    end,

    --数字格式化
    numberFormat = function(value)
        local txt = ""
        if (value > 10000 * 10000 * 10000 * 10000) then
            txt = string.format('%.2f', value / 10000 * 10000 * 10000 * 10000) .. "亿亿"
        elseif (value > 10000 * 10000 * 10000) then
            txt = string.format('%.2f', value / 10000 * 10000 * 10000) .. "万亿"
        elseif (value > 10000 * 10000) then
            txt = string.format('%.2f', value / 10000 * 10000) .. "亿"
        elseif (value > 10000) then
            txt = string.format('%.2f', value / 10000) .. "万"
        elseif (value > 1000) then
            txt = string.format('%.2f', value / 1000) .. "千"
        else
            txt = string.format('%.2f', value)
        end
        return txt
    end,

    --获取两个坐标间角度，如果其中一个单位为空 返回0
    getDegBetweenXY = function(x1, y1, x2, y2)
        --return bj_RADTODEG * cj.Atan2(y2 - y1, x2 - x1)
        return bj_RADTODEG * math.atan2(y2 - y1, x2 - x1)
    end,
    --获取两个点间角度，如果其中一个单位为空 返回0
    getDegBetweenLoc = function(l1, l2)
        if (l1 == nil or l2 == nil) then
            return 0
        end
        return hlogin.getDegBetweenXY(cj.GetLocationX(l1), cj.GetLocationY(l1), cj.GetLocationX(l2), cj.GetLocationY(l2))
    end,
    --获取两个单位间角度，如果其中一个单位为空 返回0
    getDegBetweenUnit = function(u1, u2)
        if (u1 == nil or u2 == nil) then
            return 0
        end
        return hlogin.getDegBetweenXY(cj.GetUnitX(u1), cj.GetUnitY(u1), cj.GetUnitX(u2), cj.GetUnitY(u2))
    end,

    --获取两个坐标距离
    getDistanceBetweenXY = function(x1, y1, x2, y2)
        local dx = x2 - x1
        local dy = y2 - y1
        return SquareRoot(dx * dx + dy * dy)
    end,
    --获取两个点距离
    getDistanceBetweenLoc = function(l1, l2)
        return hlogin.getDistanceBetweenXY(cj.GetLocationX(l1), cj.GetLocationY(l1), cj.GetLocationX(l2), cj.GetLocationY(l2))
    end,
    --获取两个单位距离
    getDistanceBetweenUnit = function(u1, u2)
        return hlogin.getDistanceBetweenXY(cj.GetUnitX(u1), cj.GetUnitY(u1), cj.GetUnitX(u2), cj.GetUnitY(u2))
    end,

}
