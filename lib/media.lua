hmedia = {
    bgmDelay = 3.00
}
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
-- 如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
hmedia.bgm = function(musicFileName)
    if (musicFileName ~= null and string.len(musicFileName) > 0) then
        cj.StopMusic(true)
        htime.setTimeout(hmedia.bgmDelay, function(t, td)
            htime.delDialog(td)
            htime.delTimer(t)
            cj.PlayMusic(txt)
            for i = 1, hplayer.qty_max, 1 do
                hplayerData[hplayer.players[i]].currentBgm = musicFileName
            end
            hmedia.bgmDelay = hmedia.bgmDelay - 1.50
        end)
        hmedia.bgmDelay = hmedia.bgmDelay + 1.50
    end
end
---对玩家播放BGM
-- 如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
hmedia.bgm2Player = function(musicFileName, whichPlayer)
    if (musicFileName ~= null and string.len(musicFileName) > 0 and whichPlayer ~= nil and hplayerData[whichPlayer].currentBgm ~= musicFileName) then
        if (cj.GetLocalPlayer() == whichPlayer) then
            cj.StopMusic(true)
            htime.setTimeout(hmedia.bgmDelay, function(t, td)
                htime.delDialog(td)
                htime.delTimer(t)
                cj.PlayMusic(txt)
                hplayerData[whichPlayer].currentBgm = musicFileName
                hmedia.bgmDelay = hmedia.bgmDelay - 1.50
            end)
            hmedia.bgmDelay = hmedia.bgmDelay + 1.50
        end
    end
end
hmedia.bgmStop = function(whichPlayer)
    if (whichPlayer == nil) then
        cj.StopMusic(true)
    elseif (cj.GetLocalPlayer() == whichPlayer) then
        cj.StopMusic(true)
    end
end
