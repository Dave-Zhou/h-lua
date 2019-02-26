hcameraData = {}
hcamera = {
    -- 镜头模式
    model = "normal",
}

-- 重置镜头
hcamera.reset = function(whichPlayer, during)
    if (whichPlayer == nil or cj.GetLocalPlayer() == whichPlayer) then
        cj.ResetToGameCamera(during)
    end
end
-- 应用镜头
hcamera.apply = function(whichPlayer, during, camerasetup)
    if (whichPlayer == nil or cj.GetLocalPlayer() == whichPlayer) then
        cj.CameraSetupApplyForceDuration(camerasetup, true, during)
    end
end
-- 移动到XY
hcamera.toXY = function(whichPlayer, during, x, y)
    if (whichPlayer == nil or cj.GetLocalPlayer() == whichPlayer) then
        cj.PanCameraToTimed(x, y, during)
    end
end
-- 移动到点
hcamera.toLoc = function(whichPlayer, during, loc)
    hcamera.toXY(whichPlayer, during, cj.GetLocationX(loc), cj.GetLocationY(loc))
end
-- 锁定镜头
hcamera.lock = function(whichPlayer, whichUnit)
    if (whichPlayer == nil or cj.GetLocalPlayer() == whichPlayer) then
        cj.SetCameraTargetController(whichUnit, 0, 0, false)
    end
end
-- 设定镜头距离
hcamera.zoom = function(whichPlayer, distance)
    if (whichPlayer == nil or cj.GetLocalPlayer() == whichPlayer) then
        cj.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, distance, 0)
    end
end
-- 玩家镜头震动，震动包括两种，一种摇晃shake，一种抖动
-- scale 振幅 - 摇晃
hcamera.shock = function(whichPlayer, whichType, during, scale)
    if (whichPlayer == nil) then
        return
    end
    if (whichType ~= "shake" or whichType ~= "quake") then
        return
    end
    if (during == nil) then
        during = 0.10 -- 假如没有设置时间，默认0.10秒意思意思一下
    end
    if (scale == nil) then
        scale = 5.00 -- 假如没有振幅，默认5.00意思意思一下
    end
    -- 镜头动作降噪
    if (hcameraData[whichPlayer] == true) then
        return
    else
        cameraData[whichPlayer] = true
    end
    if (whichType == 'shake') then
        cj.CameraSetTargetNoiseForPlayer(whichPlayer, scale, 1.00)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            if (cj.GetLocalPlayer() == whichPlayer) then
                cj.CameraSetTargetNoise(0, 0)
            end
        end)
    elseif (whichType == 'quake') then
        cj.CameraSetEQNoiseForPlayer(whichPlayer, scale)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            if (cj.GetLocalPlayer() == whichPlayer) then
                cj.CameraClearNoiseForPlayer(0, 0)
            end
        end)
    end
end

-- 设置镜头模式
hcamera.setModel = function(model)
    if (model == "normal") then
        -- nothing
    elseif (model == "lock") then
        htime.setInterval(0.1, function()
            local jmax = 0
            local firstHero
            for i = 1, hplayer.qty_max, 1 do
                jmax = hhero.getPlayerUnitQty(hplayer.players[i])
                local j = 1
                while (j <= jmax or firstHero == nil) do
                    firstHero = hhero.getPlayerUnit(hplayer.players[i], j)
                    j = j + 1
                end
                if (firstHero ~= nil and his.alive(firstHero) == true and cj.GetLocalPlayer() == hplayer.players[i]) then
                    hcamera.lock(hplayer.players[i], firstHero)
                else
                    hcamera.reset(hplayer.players[i], 0)
                end
                firstHero = nil
            end
        end)
    elseif (model == "zoomin") then
        htime.setInterval(0.1, function()
            cj.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 825, 0)
        end)
        hattr.max_move_speed = hattr.max_move_speed * 2
    elseif (model == "zoomout") then
        htime.setInterval(0.1, function()
            cj.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 3300, 0)
        end)
    else
        return
    end
end

