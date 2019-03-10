hmediaCache = {}
for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
    local p = cj.Player(i - 1)
    hmediaCache[p] = {}
    hmediaCache[p].currentBgm = nil
    hmediaCache[p].bgmDelay = 3.00
end
hmedia = {}
--- 播放音效
hmedia.sound = function(s)
    if (s ~= nil) then
        cj.StartSound(s)
    end
end
--- 播放音效对某个玩家
hmedia.sound2Player = function(s, whichPlayer)
    if (s ~= nil and cj.GetLocalPlayer() == whichPlayer) then
        cj.StartSound(s)
    end
end
--- 绑定单位音效
hmedia.sound2Unit = function(s, volumePercent, u)
    if (s ~= nil) then
        cj.AttachSoundToUnit(s, u)
        cj.SetSoundVolume(s, cj.PercentToInt(volumePercent, 127))
        cj.StartSound(s)
    end
end
--- 绑定坐标音效
hmedia.sound2XYZ = function(s, x, y, z)
    if (s ~= nil) then
        cj.SetSoundPosition(s, x, y, z)
    end
end
--- 绑定点音效
hmedia.sound2Loc = function(s, loc)
    hmedia.sound2XYZ(s, cj.GetLocationX(loc), cj.GetLocationY(loc), cj.GetLocationZ(loc))
end

---播放BGM
-- 当whichPlayer为nil时代表对全员操作
-- 如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
-- 由于音乐快速切换会卡顿，所以有3秒的延时（如果同时切换很多次延时会累积！所以请不要过分地切换BGM）
-- 延时是每个玩家独立时间，当切换的BGM为同一首时，切换不会进行
hmedia.bgm = function(musicFileName, whichPlayer)
    if (musicFileName ~= null and string.len(musicFileName) > 0) then
        if (whichPlayer ~= nil and hmediaCache[whichPlayer].currentBgm ~= musicFileName) then
            return
        end
        for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
            local p = cj.Player(i - 1)
            if (whichPlayer == nil or (p == whichPlayer and cj.GetLocalPlayer() == whichPlayer)) then
                if(hmediaCache[p].currentBgm ~= musicFileName)then
                    hmediaCache[p].currentBgm = musicFileName
                    cj.StopMusic(true)
                    htime.setTimeout(hmediaCache[p].bgmDelay, function(t, td)
                        htime.delDialog(td)
                        htime.delTimer(t)
                        cj.PlayMusic(txt)
                        hmediaCache[p].bgmDelay = hmediaCache[p].bgmDelay - 3.00
                    end)
                    hmediaCache[p].bgmDelay = hmediaCache[p].bgmDelay + 3.00
                end
            end
        end
    end
end
--- 停止BGM
hmedia.bgmStop = function(whichPlayer)
    if (whichPlayer == nil) then
        cj.StopMusic(true)
    elseif (cj.GetLocalPlayer() == whichPlayer) then
        cj.StopMusic(true)
    end
end
