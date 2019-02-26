henvData = {
    doodad = {
        block = { 'LTba' },
        cage = { 'LOcg' },
        bucket = { 'LTbr', 'LTbx', 'LTbs' },
        bucketBrust = { 'LTex' },
        box = { 'LTcr' },
        supportColumn = { 'BTsc' },
        stone = { 'LTrc' },
        stoneRed = { 'DTrc' },
        stoneIce = { 'ITcr' },
        ice = { 'ITf1', 'ITf2', 'ITf3', 'ITf4' },
        spiderEggs = { 'DTes' },
        volcano = { 'Volc' }, -- 火山
        treeSummer = { 'LTlt' },
        treeAutumn = { 'FTtw' },
        treeWinter = { 'WTtw' },
        treeWinterShow = { 'WTst' },
        treeDark = { 'NTtw' }, -- 枯枝
        treeDarkUmbrella = { 'NTtc' }, -- 伞
        treePoor = { 'BTtw' }, -- 贫瘠
        treePoorUmbrella = { 'BTtc' }, -- 伞
        treeRuins = { 'ZTtw' }, -- 遗迹
        treeRuinsUmbrella = { 'ZTtc' }, -- 伞
        treeFire = { 'ZTtw' }, -- 炼狱
        treeUnderground = { 'DTsh', 'GTsh' }, -- 地下城
    },
    ground = {
        summer = { 'Adrg' },
        autumn = { 'Ydtr' },
        winter = { 'Agrs' },
        winterDeep = { 'Agrs' },
        dark = { 'Xblm' },
        poor = { 'Adrd' },
        ruins = { 'Xhdg' },
        fire = { 'Yblm' },
        underground = { 'Yrtl' },
    },
}
henv = {
    build = function(whichRect, typeStr, excludeX, excludeY, isDestroyRect, ground, doodad, units)
        if (whichRect == nil or typeStr == nil) then
            return
        end
        if (ground == nil or doodad == nil or units == nil) then
            return
        end
        --清理装饰物
        cj.EnumDestructablesInRectAll(whichRect, function()
            cj.RemoveDestructable(cj.GetEnumDestructable())
        end)
        local rectStartX = hrect.getStartX(whichRect)
        local rectStartY = hrect.getStartY(whichRect)
        local rectEndX = hrect.getEndX(whichRect)
        local rectEndY = hrect.getEndY(whichRect)
        local indexX = -1
        local indexY = -1
        local midX = (rectEndX - rectStartX) * 0.5
        local midY = (rectEndY - rectStartY) * 0.5
        local doodads = {}
        for k, v in pairs(doodad) do
            for kk, vv in pairs(v) do
                table.insert(doodads, vv)
            end
        end
        htime.setInterval(0.01, nil, function(t, td)
            local x = rectStartX + indexX * 80
            local y = rectStartY + indexY * 80
            local buildType = cj.GetRandomInt(1, 4)
            if (x >= rectEndX and y >= rectEndY) then
                htime.delTimer(t)
                if (isDestroyRect) then
                    cj.RemoveRect(whichRect)
                end
                return
            end
            if (x >= rectEndX) then
                indexY = 1 + indexY
                indexX = -1
            end
            if (y >= rectEndY) then
                indexY = -1
            end
            indexX = 1 + indexX
            if (math.abs(x - midX) < (excludeX * 0.5) and math.abs(y - midY) < (excludeY * 0.5)) then
                return
            end
            if (buildType == 1 and uid <= 0) then
                buildType = 2
            end
            if (buildType == 2 and did <= 0) then
                buildType = -1
            end
            if (buildType == -1) then
                return
            end
            if (buildType == 1) then
                cj.GroupAddUnit(env_u_group, hunit.createUnitXY(hplayer.player_passive, units[math.random(1, #units)], x, y))
            elseif (buildType == 2) then
                cj.SetDestructableInvulnerable(cj.CreateDestructable(doodads[math.random(1, #doodads)], x, y, cj.GetRandomDirectionDeg(), cj.GetRandomReal(0.5, 1.1), 0), true)
                if (ground ~= nil) then
                    cj.SetTerrainType(x, y, ground, -1, 1, 0)
                end
            end
        end)
    end,
    random = function(whichRect, typeStr, excludeX, excludeY, isDestroyRect)
        local ground
        local doodad = {}
        local unit = {}
        if (whichRect == nil or typeStr == nil) then
            return
        end
        if (typeStr == "summer") then
            ground = henvData.ground.summer
            doodad = {
                henvData.doodad.treeSummer,
                henvData.doodad.block,
                henvData.doodad.stone,
                henvData.doodad.bucket,
            }
            unit = {
                hslk_global.env_model.flower0,
                hslk_global.env_model.flower1,
                hslk_global.env_model.flower2,
                hslk_global.env_model.flower3,
                hslk_global.env_model.flower4,
                hslk_global.env_model.bird,
            }
        elseif (typeStr == "autumn") then
            ground = henvData.ground.autumn
            doodad = {
                henvData.doodad.treeAutumn,
                henvData.doodad.box,
                henvData.doodad.stoneRed,
                henvData.doodad.bucket,
                henvData.doodad.cage,
                henvData.doodad.supportColumn,
            }
            unit = {
                hslk_global.env_model.flower0,
                hslk_global.env_model.typha0,
                hslk_global.env_model.typha1,
            }
        elseif (typeStr == "winter") then
            ground = henvData.ground.winter
            doodad = {
                henvData.doodad.treeWinter,
                henvData.doodad.treeWinterShow,
                henvData.doodad.cage,
                henvData.doodad.stoneIce,
            }
            unit = {
                hslk_global.env_model.stone0,
                hslk_global.env_model.stone1,
                hslk_global.env_model.stone2,
                hslk_global.env_model.stone3,
                hslk_global.env_model.stone_show0,
                hslk_global.env_model.stone_show1,
                hslk_global.env_model.stone_show2,
                hslk_global.env_model.stone_show3,
                hslk_global.env_model.stone_show4,
            }
        elseif (typeStr == "winterDeep") then
            ground = henvData.ground.winterDeep
            doodad = {
                henvData.doodad.treeWinterShow,
                henvData.doodad.cage,
                henvData.doodad.stoneIce,
            }
            unit = {
                hslk_global.env_model.stone_show5,
                hslk_global.env_model.stone_show6,
                hslk_global.env_model.stone_show7,
                hslk_global.env_model.stone_show8,
                hslk_global.env_model.stone_show9,
                hslk_global.env_model.ice0,
                hslk_global.env_model.ice1,
                hslk_global.env_model.ice2,
                hslk_global.env_model.ice3,
                hslk_global.env_model.bubble_geyser_steam,
                hslk_global.env_model.snowman,
            }
        elseif (typeStr == "dark") then
            ground = henvData.ground.dark
            doodad = {
                henvData.doodad.treeDark,
                henvData.doodad.treeDarkUmbrella,
                henvData.doodad.cage,
            }
            unit = {
                hslk_global.env_model.rune0,
                hslk_global.env_model.rune1,
                hslk_global.env_model.rune2,
                hslk_global.env_model.rune3,
                hslk_global.env_model.rune4,
                hslk_global.env_model.rune5,
                hslk_global.env_model.rune6,
                hslk_global.env_model.impaled_body0,
                hslk_global.env_model.impaled_body1,
            }
        elseif (typeStr == "poor") then
            ground = henvData.ground.poor
            doodad = {
                henvData.doodad.treePoor,
                henvData.doodad.treePoorUmbrella,
                henvData.doodad.cage,
                henvData.doodad.box,
            }
            unit = {
                hslk_global.env_model.bone0,
                hslk_global.env_model.bone1,
                hslk_global.env_model.bone2,
                hslk_global.env_model.bone3,
                hslk_global.env_model.bone4,
                hslk_global.env_model.bone5,
                hslk_global.env_model.bone6,
                hslk_global.env_model.bone7,
                hslk_global.env_model.bone8,
                hslk_global.env_model.bone9,
                hslk_global.env_model.flies,
                hslk_global.env_model.burn_body0,
                hslk_global.env_model.burn_body1,
                hslk_global.env_model.burn_body3,
                hslk_global.env_model.bats,
            }
        elseif (typeStr == "ruins") then
            ground = henvData.ground.ruins
            doodad = {
                henvData.doodad.treeRuins,
                henvData.doodad.treeRuinsUmbrella,
                henvData.doodad.cage,
            }
            unit = {
                hslk_global.env_model.break_column0,
                hslk_global.env_model.break_column1,
                hslk_global.env_model.break_column2,
                hslk_global.env_model.break_column3,
                hslk_global.env_model.skull_pile0,
                hslk_global.env_model.skull_pile1,
                hslk_global.env_model.skull_pile2,
                hslk_global.env_model.skull_pile3,
            }
        elseif (typeStr == "fire") then
            ground = henvData.ground.fire
            doodad = {
                henvData.doodad.treeFire,
                henvData.doodad.volcano,
                henvData.doodad.stoneRed,
            }
            unit = {
                hslk_global.env_model.fire_hole,
                hslk_global.env_model.burn_body0,
                hslk_global.env_model.burn_body1,
                hslk_global.env_model.burn_body2,
                hslk_global.env_model.firetrap,
                hslk_global.env_model.fire,
                hslk_global.env_model.burn_build,
            }
        elseif (typeStr == "underground") then
            ground = henvData.ground.underground
            doodad = {
                henvData.doodad.treeUnderground,
                henvData.doodad.spiderEggs,
            }
            unit = {
                hslk_global.env_model.mushroom0,
                hslk_global.env_model.mushroom1,
                hslk_global.env_model.mushroom2,
                hslk_global.env_model.mushroom3,
                hslk_global.env_model.mushroom4,
                hslk_global.env_model.mushroom5,
                hslk_global.env_model.mushroom6,
                hslk_global.env_model.mushroom7,
                hslk_global.env_model.mushroom8,
                hslk_global.env_model.mushroom9,
                hslk_global.env_model.mushroom10,
                hslk_global.env_model.mushroom11,
            }
        elseif (typeStr == "sea") then
            ground = henvData.ground.ruins
            doodad = {
                henvData.doodad.stone,
            }
            unit = {
                hslk_global.env_model.seaweed0,
                hslk_global.env_model.seaweed1,
                hslk_global.env_model.seaweed2,
                hslk_global.env_model.seaweed3,
                hslk_global.env_model.seaweed4,
                hslk_global.env_model.fish,
                hslk_global.env_model.fish_school,
                hslk_global.env_model.fish_green,
                hslk_global.env_model.bubble_geyser,
                hslk_global.env_model.bubble_geyser_steam,
                hslk_global.env_model.coral0,
                hslk_global.env_model.coral1,
                hslk_global.env_model.coral2,
                hslk_global.env_model.coral3,
                hslk_global.env_model.coral4,
                hslk_global.env_model.coral5,
                hslk_global.env_model.coral6,
                hslk_global.env_model.coral7,
                hslk_global.env_model.coral8,
                hslk_global.env_model.coral9,
                hslk_global.env_model.shells0,
                hslk_global.env_model.shells1,
                hslk_global.env_model.shells2,
                hslk_global.env_model.shells3,
                hslk_global.env_model.shells4,
                hslk_global.env_model.shells5,
                hslk_global.env_model.shells6,
                hslk_global.env_model.shells7,
                hslk_global.env_model.shells8,
                hslk_global.env_model.shells9,
            }
        elseif (typeStr == "river") then
            ground = henvData.ground.ruins
            doodad = {
                henvData.doodad.stone,
            }
            unit = {
                hslk_global.env_model.fish,
                hslk_global.env_model.fish_school,
                hslk_global.env_model.fish_green,
                hslk_global.env_model.lilypad0,
                hslk_global.env_model.lilypad1,
                hslk_global.env_model.lilypad2,
                hslk_global.env_model.river_rushes0,
                hslk_global.env_model.river_rushes1,
                hslk_global.env_model.river_rushes2,
                hslk_global.env_model.river_rushes3,
            }
        else
            return
        end
        henv.build(whichRect, typeStr, excludeX, excludeY, isDestroyRect, ground, doodad, unit)
    end,
}
