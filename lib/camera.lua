hcameraCache = {}
for i = 1, 12, 1 do
    local p = cj.Player(i - 1)
    hcameraCache[p] = {}
    hcameraCache[p].model = "normal" -- 镜头模型
    hcameraCache[p].isShocking = false
end
hcamera = {}

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
-- whichUnit = {} 以玩家为key
hcamera.lock = function(whichPlayer, whichUnit)
    if (whichPlayer ~= nil or cj.GetLocalPlayer() == whichPlayer) then
        if (his.alive(whichUnit[whichPlayer]) == true) then
            cj.SetCameraTargetController(whichUnit[whichPlayer], 0, 0, false)
        else
            hcamera.reset(whichPlayer, 0)
        end
    else
        for i = 1, 12, 1 do
            local p = cj.Player(i - 1)
            if (his.alive(whichUnit[p]) == true) then
                cj.SetCameraTargetController(whichUnit[p], 0, 0, false)
            else
                hcamera.reset(p, 0)
            end
        end
    end
end
-- 设定镜头距离
hcamera.distance = function(whichPlayer, distance)
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
    if (hcameraCache[whichPlayer].isShocking == true) then
        return
    end
    cameraData[whichPlayer].isShocking = true
    if (whichType == 'shake') then
        cj.CameraSetTargetNoiseForPlayer(whichPlayer, scale, 1.00)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cameraData[whichPlayer].isShocking = false
            if (cj.GetLocalPlayer() == whichPlayer) then
                cj.CameraSetTargetNoise(0, 0)
            end
        end)
    elseif (whichType == 'quake') then
        cj.CameraSetEQNoiseForPlayer(whichPlayer, scale)
        htime.setTimeout(during, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cameraData[whichPlayer].isShocking = false
            if (cj.GetLocalPlayer() == whichPlayer) then
                cj.CameraClearNoiseForPlayer(0, 0)
            end
        end)
    end
end

--- 获取镜头模型
hcamera.getModel = function(whichPlayer)
    return hcameraCache[whichPlayer].model
end
--- 设置镜头模式
--[[
 bean = {
    model = "normal" | "lock",
    whichPlayer = nil, -- 锁定单位的玩家
    lockUnit = {}, -- 锁定单位的绑定单位,与玩家对应
 }
]]
hcamera.setModel = function(bean)
    if (bean.model == nil) then
        return
    end
    if (bean.model == "normal") then
        hcamera.reset(bean.whichPlayer, 0)
    elseif (bean.model == "lock") then
        if (bean.lockUnit == nil or bean.whichPlayer == nil) then
            return
        end
        htime.setInterval(0.1, function()
            hcamera.lock(bean.whichPlayer, bean.lockUnit)
        end)
    elseif (bean.model == "zoomin") then
        htime.setInterval(0.1, function()
            hcamera.distance(bean.whichPlayer, 825)
        end)
        -- hattr.max_move_speed = hattr.max_move_speed * 2
    elseif (bean.model == "zoomout") then
        htime.setInterval(0.1, function()
            hcamera.distance(bean.whichPlayer, 3000)
        end)
    else
        return
    end
    if (bean.whichPlayer ~= nil) then
        hcameraCache[bean.whichPlayer].model = bean.model
    else
        for i = 1, 12, 1 do
            local p = cj.Player(i - 1)
            hcameraCache[p].model = bean.model
        end
    end
end

