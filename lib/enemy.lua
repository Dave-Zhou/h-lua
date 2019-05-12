--todo 敌人模块
local henemy = {
    players = {}, -- 充当敌人的玩家
    numbers = {}, -- 充当敌人的玩家调用次数，默认 0
    numberLimit = 100000, -- 充当敌人的玩家调用次数上限，达到就全体归0
    name = "敌军",
}

--- 设置敌人的名称
henemy.setName = function(name)
    henemy.name = name
end
--- 获取敌人的名称
henemy.getName = function()
    return henemy.name
end
--- 将某个玩家位置设定为敌人，同时将他名字设定为全局的emptyName，颜色调节为黑色ConvertPlayerColor(12)
henemy.setPlayer = function(whichPlayer)
    table.insert(henemy.players, whichPlayer)
    if (henemy.numbers[whichPlayer] == nil) then
        henemy.numbers[whichPlayer] = 0
    end
    cj.SetPlayerName(whichPlayer, henemy.name)
    cj.SetPlayerColor(whichPlayer, cj.ConvertPlayerColor(12))
end
--- 最优化自动获取一个敌人玩家
-- createQty 可设定创建单位数，更精准调用，默认权重 1
henemy.getPlayer = function(createQty)
    local len = #henemy.players
    local p
    if (createQty == nil) then
        createQty = 1
    else
        createQty = math.floor(createQty)
    end
    for i = 1, len, 1 do
        if (p == nil) then
            p = henemy.players[i]
        elseif (henemy.numbers[henemy.players[i]] < henemy.numbers[p]) then
            p = henemy.players[i]
        end
    end
    henemy.numbers[p] = henemy.numbers[p] + createQty
    if (henemy.numbers[p] > henemy.numberLimit) then
        for i = 1, len, 1 do
            henemy.numbers[henemy.players[i]] = 0
        end
    end
    return p
end
--[[
    创建敌人单位/单位组
    @return 最后创建单位/单位组
    {
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
        isInvulnerable = false, --是否无敌，可选
    }
]]
henemy.create = function(bean)
    bean.whichPlayer = henemy.getPlayer(bean.qty)
    return hunit.create(bean)
end

return henemy
