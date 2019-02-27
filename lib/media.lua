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

--- 播放BGM
hmedia.bgm = function(musicFileName)
    
end

--[[

	private static method bgmCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local string txt = htime.getString(t,1)
		local integer i = 0
		call PlayMusic(txt)
		call htime.delTimer(t)
		set t = null
		set i = player_max_qty
		loop
			exitwhen i<=0
				set bgmCurrent[i] = txt
			set i = i-1
		endloop
		set txt = null
	endmethod
	//播放音乐，如果背景音乐无法循环播放，尝试格式工厂转wav再转回mp3
	public static method bgm takes string musicFileName returns nothing
		local timer t = null
		if(musicFileName!=null and musicFileName!="")then
			call StopMusic( true )
			set t = htime.setTimeout(bgmDelay,function thistype.bgmCall)
			call htime.setString(t,1,musicFileName)
			set t = null
		endif
	endmethod

	private static method bgm2PlayerCall takes nothing returns nothing
		local timer t = GetExpiredTimer()
		local string txt = htime.getString(t,1)
		local player p = htime.getPlayer(t,2)
		if(GetLocalPlayer() == p)then
			set bgmCurrent[GetConvertedPlayerId(p)] = txt
			call PlayMusic(txt)
		endif
		call htime.delTimer(t)
		set t = null
		set txt = null
		set p = null
	endmethod
	//对玩家播放音乐
	public static method bgm2Player takes string musicFileName,player whichPlayer returns nothing
		local timer t = GetExpiredTimer()
		if(musicFileName!=null and musicFileName!="" and whichPlayer != null)then
			if(GetLocalPlayer() == whichPlayer)then
				call StopMusic( true )
				set t = htime.setTimeout(bgmDelay,function thistype.bgm2PlayerCall)
				call htime.setString(t,1,musicFileName)
				call htime.setPlayer(t,2,whichPlayer)
				set t = null
			endif
		endif
	endmethod

	// 停止BGM
	public static method bgmStop takes nothing returns nothing
		call StopMusic( true )
	endmethod
	public static method bgmStop2Player takes player whichPlayer returns nothing
		if(GetLocalPlayer() == whichPlayer)then
			call StopMusic( true )
		endif
	endmethod

endstruct
