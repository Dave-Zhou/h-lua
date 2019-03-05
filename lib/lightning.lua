hLightningType = {
    shan_dian_lian_zhu = "CLPB", -- 闪电效果 - 闪电链主
    shan_dian_lian_ci = "CLSB", -- 闪电效果 - 闪电链次
    ji_qu = "DRAB", -- 闪电效果 - 汲取
    sheng_ming_ji_qu = "DRAL", -- 闪电效果 - 生命汲取
    mo_fa_ji_qu = "DRAM", -- 闪电效果 - 魔法汲取
    si_wang_zhi_zhi = "AFOD", -- 闪电效果 - 死亡之指
    cha_zhuang_shan_dian = "FORK", -- 闪电效果 - 叉状闪电
    yi_liao_bo_zhu = "HWPB", -- 闪电效果 - 医疗波主
    yi_liao_bo_ci = "HWSB", -- 闪电效果 - 医疗波次
    shan_dian_gong_ji = "CHIM", -- 闪电效果 - 闪电攻击
    ma_fa_liao_kao = "LEAS", -- 闪电效果 - 魔法镣铐
    fa_li_ran_shao = "MBUR", -- 闪电效果 - 法力燃烧
    mo_li_zhi_yan = "MFPB", -- 闪电效果 - 魔力之焰
    ling_hun_suo_lian = "SPLK", -- 闪电效果 - 灵魂锁链
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