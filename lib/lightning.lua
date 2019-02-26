hLightningType = {
    shandianlian_zhu = "CLPB", -- 闪电效果 - 闪电链主
    shandianlian_ci = "CLSB", -- 闪电效果 - 闪电链次
    jiqu = "DRAB", -- 闪电效果 - 汲取
    shengming_jiqu = "DRAL", -- 闪电效果 - 生命汲取
    mofa_jiqu = "DRAM", -- 闪电效果 - 魔法汲取
    siwangzhizhi = "AFOD", -- 闪电效果 - 死亡之指
    chazhuangshandian = "FORK", -- 闪电效果 - 叉状闪电
    yiliaobo_zhu = "HWPB", -- 闪电效果 - 医疗波主
    yiliaobo_ci = "HWSB", -- 闪电效果 - 医疗波次
    shandian_gongji = "CHIM", -- 闪电效果 - 闪电攻击
    mafa_liaokao = "LEAS", -- 闪电效果 - 魔法镣铐
    fali_ranshao = "MBUR", -- 闪电效果 - 法力燃烧
    molizhiyan = "MFPB", -- 闪电效果 - 魔力之焰
    linghunsuolian = "SPLK", -- 闪电效果 - 灵魂锁链
}
hLightning = {
    del = function(lightning)
        cj.DestroyLightning(lightning)
    end,
    xyz2xyz = function(codename, x1, y1, z1, x2, y2, z2, during)
        local lightning = cj.AddLightningEx(hsystem.getObjId(codename), true, x1, y1, z1, x2, y2, z2)
        if (during > 0) then
            htime.setTimeout(during, nil, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                hLightning.del(lightning)
            end)
        end
        return lightning
    end,
    loc2loc = function(codename, loc1, loc2, during)
        return hLightning.xyz2xyz(
                codename,
                cj.GetLocationX(loc1), cj.GetLocationY(loc1), cj.GetLocationZ(loc1),
                cj.GetLocationX(loc2), cj.GetLocationY(loc2), cj.GetLocationZ(loc2),
                during)
    end,
    unit2unit = function(codename, unit1, unit2, during)
        return hLightning.xyz2xyz(
                codename,
                cj.GetUnitX(unit1), cj.GetUnitY(unit1), cj.GetUnitFlyHeight(unit1),
                cj.GetUnitX(unit2), cj.GetUnitY(unit2), cj.GetUnitFlyHeight(unit2),
                during)
    end,
}