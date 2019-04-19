hunitCache = {}
hunit = {

    -- 获取单位的最大生命值
    getMaxLife = function(u)
        return cj.GetUnitState(u, UNIT_STATE_MAX_LIFE)
    end,
    -- 获取单位的当前生命
    getCurLife = function(u)
        return cj.GetUnitState(u, UNIT_STATE_LIFE)
    end,
    -- 设置单位的当前生命
    setLife = function(u, val)
        cj.SetUnitState(u, UNIT_STATE_LIFE, val)
    end,
    -- 增加单位的当前生命
    addLife = function(u, val)
        cj.SetUnitState(u, UNIT_STATE_LIFE, hunit.curLife(u) + val)
    end,
    -- 减少单位的当前生命
    subLife = function(u, val)
        cj.SetUnitState(u, UNIT_STATE_LIFE, hunit.getLife(u) - val)
    end,
    -- 获取单位的最大魔法
    getMaxMana = function(u)
        return cj.GetUnitState(u, UNIT_STATE_MAX_MANA)
    end,
    -- 获取单位的当前魔法
    getCurMana = function(u)
        return cj.GetUnitState(u, UNIT_STATE_MANA)
    end,
    -- 设置单位的当前魔法
    setMana = function(u, val)
        cj.SetUnitState(u, UNIT_STATE_MANA, val)
    end,
    -- 增加单位的当前魔法
    addMana = function(u, val)
        cj.SetUnitState(u, UNIT_STATE_MANA, hunit.getMana(u) + val)
    end,
    -- 减少单位的当前魔法
    subMana = function(u, val)
        cj.SetUnitState(u, UNIT_STATE_MANA, hunit.getMana(u) - val)
    end,

    -- 获取单位百分比生命
    getLifePercent = function(u)
        return cj.GetUnitLifePercent(u)
    end,
    -- 设置单位百分比生命
    setLifePercent = function(u, val)
        cj.SetUnitLifePercentBJ(u, val)
    end,
    -- 获取单位百分比魔法
    getManaPercent = function(u)
        return cj.GetUnitManaPercent(u)
    end,
    -- 设置单位百分比魔法
    setManaPercent = function(u, val)
        cj.SetUnitManaPercentBJ(u, val)
    end,
    -- 设置单位的生命周期
    setPeriod = function(u, life)
        cj.UnitApplyTimedLifeBJ(life, hsystem.getObjId('BTLF'), u)
    end,

    --获取单位面向角度
    getFacing = function(u)
        return cj.GetUnitFacing(u)
    end,

    --单位是否启用硬直（系统默认不启用）
    isOpenPunish = function(u)
        return hunitCache[u].isOpenPunish
    end,

    --[[
        创建单位/单位组
        @return 最后创建单位/单位组
        {
            whichPlayer = nil, --归属玩家
            unitId = nil, --类型id,如'H001'
            x = nil, --创建坐标X，可选
            y = nil, --创建坐标Y，可选
            loc = nil, --创建点，可选
            height = 高度，0，可选
            timeScalePercent = 动作时间比例，1~，可选
            modelScalePercent = 模型缩放比例，1~，可选
            opacity = 透明，0～255，可选
            qty = 1, --数量，可选，可选
            life = nil, --生命周期，到期死亡，可选
            during = nil, --持续时间，到期删除，可选
            facing = nil, --面向角度，可选
            facingX = nil, --面向X，可选
            facingY = nil, --面向Y，可选
            facingLoc = nil, --面向点，可选
            facingUnit = nil, --面向单位，可选
            attackX = nil, --攻击X，可选
            attackY = nil, --攻击Y，可选
            attackLoc = nil, --攻击点，可选
            attackUnit = nil, --攻击单位，可选
            isOpenPunish = false, --是否开启硬直系统，可选
            isShadow = false, --是否影子，可选
            isUnSelectable = false, --是否可鼠标选中，可选
            isPause = false, -- 是否暂停
            isInvulnerable = false, --是否无敌，可选
        }
    ]]
    create = function(bean)
        if (bean.whichPlayer == nil or bean.unitId == nil or bean.qty <= 0) then
            print('create unit fail -pl-id')
            return
        end
        if (bean.x == nil and bean.y == nil and bean.loc == nil) then
            print('create unit fail -place')
            return
        end
        if (bean.unitId == nil) then
            print('create unit id')
            return
        end
        bean.unitId = hsystem.getObjId(bean.unitId)
        local u
        local facing
        local x
        local y
        local g
        if (bean.x ~= nil and bean.y ~= nil) then
            x = bean.x
            y = bean.y
        elseif (bean.loc ~= nil) then
            x = cj.GetLocationX(bean.loc)
            y = cj.GetLocationY(bean.loc)
        end
        if (bean.facing ~= nil) then
            facing = bean.facing
        elseif (bean.facingX ~= nil and bean.facingY ~= nil) then
            facing = hlogin.getDegBetweenXY(x, y, bean.facingX, bean.facingY)
        elseif (bean.facingLoc ~= nil) then
            facing = hlogin.getDegBetweenXY(x, y, cj.GetLocationX(bean.facingLoc), cj.GetLocationY(bean.facingLoc))
        elseif (bean.facingUnit ~= nil) then
            facing = hlogin.getDegBetweenXY(x, y, cj.GetUnitX(bean.facingUnit), cj.GetUnitY(bean.facingUnit))
        else
            facing = bj_UNIT_FACING
        end
        if (bean.qty > 1) then
            g = cj.CreateGroup()
        end
        for i = 0, qty, 1 do
            if (bean.x ~= nil and bean.y ~= nil) then
                u = cj.CreateUnit(bean.whichPlayer, bean.unitId, bean.x, bean.y, facing)
            elseif (bean.loc ~= nil) then
                u = cj.CreateUnitAtLoc(bean.whichPlayer, bean.unitId, bean.loc, facing)
            end
            -- 高度
            if (bean.height ~= 0 and bean.height ~= nil) then
                bean.height = hlogin.round(bean.height)
                hunit.setCanFly(u)
                cj.SetUnitFlyHeight(u, bean.height, 10000)
            end
            -- 动作时间比例 %
            if (bean.timeScalePercent > 0 and bean.timeScalePercent ~= nil) then
                bean.timeScalePercent = hlogin.round(bean.timeScalePercent)
                cj.SetUnitTimeScalePercent(u, timeScalePercent)
            end
            -- 模型缩放比例 %
            if (bean.modelScalePercent > 0 and bean.modelScalePercent ~= nil) then
                bean.modelScalePercent = hlogin.round(bean.modelScalePercent)
                cj.SetUnitScalePercent(u, bean.modelScalePercent, bean.modelScalePercent, bean.modelScalePercent)
            end
            -- 透明比例
            if (bean.opacity <= 255 and bean.opacity >= 0 and bean.opacity ~= nil) then
                bean.opacity = hlogin.round(bean.opacity)
                cj.SetUnitVertexColor(u, 255, 255, 255, bean.opacity)
            end
            -- 生命周期 dead
            if (bean.life > 0) then
                hunit.setPeriod(u, bean.life)
            end
            -- 持续时间 delete
            if (bean.during > 0) then
                hunit.del(u, bean.during)
            end
            if (bean.attackX ~= nil and bean.attackY ~= nil) then
                cj.IssuePointOrder(u, "attack", bean.attackX, bean.attackY)
            elseif (bean.attackLoc ~= nil) then
                cj.IssuePointOrderLoc(u, "attack", bean.attackLoc)
            elseif (bean.attackUnit ~= nil) then
                cj.IssueTargetOrder(u, "attack", bean.attackUnit)
            end
            if (bean.qty > 1) then
                cj.GroupAddUnit(g, u)
            end
            --是否可选
            if (bean.isUnSelectable ~= nil and bean.isUnSelectable == true) then
                cj.UnitAddAbility(u, 'Aloc')
            end
            --是否暂停
            if (bean.isPause ~= nil and bean.isPause == true) then
                cj.PauseUnit(u, true)
            end
            --是否无敌
            if (bean.isInvulnerable ~= nil and bean.isInvulnerable == true) then
                cj.SetUnitInvulnerable(u, true)
            end
            --影子，无敌蝗虫暂停
            if (bean.isShadow ~= nil and bean.isShadow == true) then
                cj.UnitAddAbility(u, 'Aloc')
                cj.PauseUnit(u, true)
                cj.SetUnitInvulnerable(u, true)
            end
            --记入realtime
            hunitCache[u] = {
                id = bean.unitId,
                whichPlayer = bean.whichPlayer,
                x = x,
                y = y,
                life = bean.life,
                during = bean.during,
                isOpenPunish = bean.isOpenPunish,
                isShadow = bean.isShadow,
            }
        end
        if (g ~= nil) then
            return g
        else
            return u
        end
    end,

    -- 获取单位ID字符串
    getId = function(u)
        return hsystem.getObjChar(cj.GetUnitTypeId(u))
    end,
    -- 获取单位数据集
    getSlk = function(u)
        local slk
        local uid = hunit.getId(u)
        if (hslk_global.unitsKV[uid] ~= nil) then
            slk = hslk_global.unitsKV[uid]
        end
        return slk
    end,
    -- 获取单位的头像
    getAvatar = function(u)
        local slk = hunit.getSlk(u)
        if (slk ~= nil) then
            return slk.Art
        else
            return "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
        end
    end,
    -- 获取单位的攻击速度间隔
    getAttackSpeedBaseSpace = function(u)
        local slk = hunit.getSlk(u)
        if (slk ~= nil) then
            return slk.cool1
        else
            return 2.00
        end
    end,
    -- 获取单位的攻击范围
    getAttackRange = function(u)
        local slk = hunit.getSlk(u)
        if (slk ~= nil) then
            return slk.rangeN1
        else
            return 100
        end
    end,

    -- 获取单位的自定义值
    getUserData = function(u)
        return cj.GetUnitUserData(u)
    end,
    -- 设置单位的自定义值
    setUserData = function(u, val, during)
        local oldData = hunit.getUserData(u)
        val = math.ceil(val)
        cj.SetUnitUserData(u, val)
        if (during > 0) then
            htime.setTimeout(during, nil, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                cj.SetUnitUserData(u, oldData)
            end)
        end
    end,

    -- 获取单位面向角度
    getFacing = function(u)
        return cj.GetUnitFacing(u)
    end,

    -- 删除单位，延时during秒
    del = function(targetUnit, during)
        if (during <= 0) then
            cj.RemoveUnit(targetUnit)
        else
            htime.setTimeout(during, nil, function(t, td)
                htime.delTimer(t)
                htime.delDialog(td)
                cj.RemoveUnit(targetUnit)
            end)
        end
    end,
    -- 杀死单位，延时during秒
    kill = function(targetUnit, during)
        if (during <= 0) then
            cj.KillUnit(targetUnit)
        else
            htime.setTimeout(during, nil, function(t, td)
                htime.delTimer(t)
                htime.delDialog(td)
                cj.KillUnit(targetUnit)
            end)
        end
    end,
    -- 爆毁单位，延时during秒
    exploded = function(targetUnit, during)
        if (during <= 0) then
            cj.SetUnitExploded(targetUnit, true)
            cj.KillUnit(targetUnit)
        else
            htime.setTimeout(during, nil, function(t, td)
                htime.delTimer(t)
                htime.delDialog(td)
                cj.SetUnitExploded(targetUnit, true)
                cj.KillUnit(targetUnit)
            end)
        end
    end,

    --设置单位可飞，用于设置单位飞行高度之前
    setCanFly = function(u)
        cj.UnitAddAbility(u, 'Amrf')
        cj.UnitRemoveAbility(u, 'Amrf')
    end,

    --在某XY坐标复活英雄,只有英雄能被复活,只有调用此方法会触发复活事件
    rebornAtXY = function(u, delay, invulnerable, x, y)
        if (his.hero(u)) then
            if (delay < 0.3) then
                cj.ReviveHero(u, x, y, true)
                hattr.resetAttrGroups(u)
                if (invulnerable > 0) then
                    hskill.invulnerable(u, invulnerable)
                end
                -- @触发复活事件
                hevt.triggerEvent({
                    triggerKey = "reborn",
                    triggerUnit = u
                })
            else
                htime.setTimeout(delay, nil, function(t, td)
                    htime.delTimer(t)
                    htime.delDialog(td)
                    cj.ReviveHero(u, x, y, true)
                    hattr.resetAttrGroups(u)
                    if (invulnerable > 0) then
                        hskill.invulnerable(u, invulnerable)
                    end
                    -- @触发复活事件
                    hevt.triggerEvent({
                        triggerKey = "reborn",
                        triggerUnit = u
                    })
                end)
            end
        end
    end,

    -- 在某点复活英雄,只有英雄能被复活,只有调用此方法会触发复活事件
    rebornAtLoc = function(u, delay, invulnerable, loc)
        hunit.rebornAtXY(u, delay, invulnerable, cj.GetLocationX(loc), cj.GetLocationY(loc))
    end

}
