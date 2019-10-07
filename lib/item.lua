-- 物品系统

--[[
    物品分为（item_type）
    1、永久型物品 forever
    2、消耗型物品 consume
    3、瞬逝型 moment

    每个英雄最大支持使用6件物品
    支持满背包合成
    物品存在重量，背包有负重，超过负重即使存在合成关系，也会被暂时禁止合成

    主动指玩家需要手动触发的技能
    被动指英雄不需要主动使用而是在满足特定条件后（如攻击成功时）自动触发的技能
    属性有三种叠加： 线性 | 非线性 | 不叠加
    属性的叠加不仅限于几率也有可能是持续时间，伤害等等
    -线性：直接叠加，如：100伤害的物品，持有2件时，造成伤害将提升为200
    -非线性：一般几率的计算为33%左右的叠加效益，如：30%几率的物品，持有两件时，触发几率将提升为42.9%左右
    -不叠加：数量不影响几率，如：30%几率的物品，持有100件也为30%
    *物品不说明的属性不涉及叠加规定，默认不叠加
]]

local hitem = {

    default_skill_item_slot = hSys.getObjId('AInv'), -- 默认物品栏技能（英雄6格那个）hjass默认全部认定这个技能为物品栏，如有需要自行更改
    default_skill_item_separate = hslk_global.skill_item_separate, -- 默认拆分物品技能
    typeMap = {
        forever = 'forever',
        consume = 'consume',
        moment = 'moment',
    }

}

-- 获取物品是否h-lua内部函数创建
hitem.isHLua = function(it)
    return hRuntime.item[it].isHLua
end
-- 设定物品是否h-lua内部函数创建
hitem.setHLua = function(it, b)
    hRuntime.item[it].isHLua = b
end

-- 删除物品，可延时
hitem.del = function(it, during)
    if (during <= 0) then
        cj.SetWidgetLife(it, 1.00)
        cj.RemoveItem(it)
    else
        htime.setTimeout(during, nil, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.SetWidgetLife(it, 1.00)
            cj.RemoveItem(it)
            hRuntime.item[it] = nil
        end)
    end
end

return hitem
