bj = {}
bj.StartSoundForPlayerBJ = function(whichPlayer, soundHandle)
    if whichPlayer == cj.GetLocalPlayer() then
        cj.StartSound(soundHandle)
    end
end
bj.VolumeGroupSetVolumeForPlayerBJ = function(whichPlayer, vgroup, scale)
    if cj.GetLocalPlayer() == whichPlayer then
        cj.VolumeGroupSetVolume(vgroup, scale)
    end
end
bj.TriggerRegisterAnyUnitEventBJ = function(trig, whichEvent)
    for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
        cj.TriggerRegisterPlayerUnitEvent(trig, cj.Player(i - 1), whichEvent, nil)
    end
end
bj.TriggerRegisterPlayerSelectionEventBJ = function(trig, whichPlayer, selected)
    if (selected) then
        return cj.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_SELECTED, nil)
    else
        return cj.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_DESELECTED, nil)
    end
end
bj.TriggerRegisterPlayerKeyEventBJ = function(trig, whichPlayer, keType, keKey)
    if keType == bj_KEYEVENTTYPE_DEPRESS then
        -- Depress event - find out what key
        if keKey == bj_KEYEVENTKEY_LEFT then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_LEFT_DOWN)
        elseif keKey == bj_KEYEVENTKEY_RIGHT then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_RIGHT_DOWN)
        elseif keKey == bj_KEYEVENTKEY_DOWN then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_DOWN_DOWN)
        elseif keKey == bj_KEYEVENTKEY_UP then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_UP_DOWN)
        else
            -- Unrecognized key - ignore the request and return failure.
            return nil
        end
    elseif keType == bj_KEYEVENTTYPE_RELEASE then
        -- Release event - find out what key
        if keKey == bj_KEYEVENTKEY_LEFT then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_LEFT_UP)
        elseif keKey == bj_KEYEVENTKEY_RIGHT then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_RIGHT_UP)
        elseif keKey == bj_KEYEVENTKEY_DOWN then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_DOWN_UP)
        elseif keKey == bj_KEYEVENTKEY_UP then
            return cj.TriggerRegisterPlayerEvent(trig, whichPlayer, EVENT_PLAYER_ARROW_UP_UP)
        else
            -- Unrecognized key - ignore the request and return failure.
            return nil
        end
    else
        -- Unrecognized type - ignore the request and return failure.
        return nil
    end
end
bj.AllowVictoryDefeatBJ = function(gameResult)
    if (gameResult == PLAYER_GAME_RESULT_VICTORY) then
        return not cj.IsNoVictoryCheat()
    end
    if (gameResult == PLAYER_GAME_RESULT_DEFEAT) then
        return not cj.IsNoDefeatCheat()
    end
    if (gameResult == PLAYER_GAME_RESULT_NEUTRAL) then
        return (not cj.IsNoVictoryCheat()) and (not cj.IsNoDefeatCheat())
    end
    return true
end
bj.CustomDefeatDialogBJ = function(whichPlayer, message)
    local t = cj.CreateTrigger()
    local d = cj.DialogCreate()
    cj.DialogSetMessage(d, message)
    cj.TriggerRegisterDialogButtonEvent(t, cj.DialogAddButton(d, cj.GetLocalizedString("GAMEOVER_QUIT_MISSION"), cj.GetLocalizedHotkey("GAMEOVER_QUIT_MISSION")))
    cj.TriggerAddAction(t, function()
        cj.PauseGame(false)
        cj.RestartGame(true)
    end)
    if (cj.GetLocalPlayer() == whichPlayer) then
        cj.EnableUserControl(true)
        if cg.bj_isSinglePlayer then
            cj.PauseGame(true)
        end
        cj.EnableUserUI(false)
    end
    cj.DialogDisplay(whichPlayer, d, true)
    bj.VolumeGroupSetVolumeForPlayerBJ(whichPlayer, SOUND_VOLUMEGROUP_UI, 1.0)
    bj.StartSoundForPlayerBJ(whichPlayer, cg.bj_defeatDialogSound)
end
bj.CustomVictoryDialogBJ = function(whichPlayer)
    local t
    local d = cj.DialogCreate()

    cj.DialogSetMessage(d, GetLocalizedString("GAMEOVER_VICTORY_MSG"))
    t = cj.CreateTrigger()
    cj.TriggerRegisterDialogButtonEvent(t, cj.DialogAddButton(d, cj.GetLocalizedString("GAMEOVER_CONTINUE"), cj.GetLocalizedHotkey("GAMEOVER_CONTINUE")))
    cj.TriggerAddAction(t, function()
        if cg.bj_isSinglePlayer then
            cj.PauseGame(false)
            -- Bump the difficulty back up to the default.
            cj.SetGameDifficulty(cj.GetDefaultDifficulty())
        end

        if cg.bj_changeLevelMapName == nil then
            cj.EndGame(cg.bj_changeLevelShowScores)
        else
            cj.ChangeLevel(cg.bj_changeLevelMapName, cg.bj_changeLevelShowScores)
        end
    end)
    t = CreateTrigger()
    cj.TriggerRegisterDialogButtonEvent(t, cj.DialogAddButton(d, cj.GetLocalizedString("GAMEOVER_QUIT_MISSION"), cj.GetLocalizedHotkey("GAMEOVER_QUIT_MISSION")))
    cj.TriggerAddAction(t, CustomVictoryQuitBJ)

    if cj.GetLocalPlayer() == whichPlayer then
        cj.EnableUserControl(true)
        if cg.bj_isSinglePlayer then
            cj.PauseGame(true)
        end
        cj.EnableUserUI(false)
    end

    cj.DialogDisplay(whichPlayer, d, true)
    bj.VolumeGroupSetVolumeForPlayerBJ(whichPlayer, SOUND_VOLUMEGROUP_UI, 1.0)
    bj.StartSoundForPlayerBJ(whichPlayer, cg.bj_victoryDialogSound)
end
bj.CustomDefeatBJ = function(whichPlayer, message)
    if AllowVictoryDefeatBJ(PLAYER_GAME_RESULT_DEFEAT) then
        cj.RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_DEFEAT)
        if not cg.bj_isSinglePlayer then
            cj.DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, cj.GetLocalizedString("PLAYER_DEFEATED"))
        end
        -- UI only needs to be displayed to users.
        if (cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
            bj.CustomDefeatDialogBJ(whichPlayer, message)
        end
    end
end
bj.CustomVictorySkipBJ = function(whichPlayer)
    if cj.GetLocalPlayer() == whichPlayer then
        if cg.bj_isSinglePlayer then
            -- Bump the difficulty back up to the default.
            cj.SetGameDifficulty(cj.GetDefaultDifficulty())
        end

        if cg.bj_changeLevelMapName == nil then
            cj.EndGame(cg.bj_changeLevelShowScores)
        else
            cj.ChangeLevel(cg.bj_changeLevelMapName, cg.bj_changeLevelShowScores)
        end
    end
end
bj.CustomVictoryBJ = function(whichPlayer, showDialog, showScores)
    if AllowVictoryDefeatBJ(PLAYER_GAME_RESULT_VICTORY) then
        cj.RemovePlayer(whichPlayer, PLAYER_GAME_RESULT_VICTORY)

        if not cg.bj_isSinglePlayer then
            cj.DisplayTimedTextFromPlayer(whichPlayer, 0, 0, 60, cj.GetLocalizedString("PLAYER_VICTORIOUS"))
        end

        -- UI only needs to be displayed to users.
        if (cj.GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
            cg.bj_changeLevelShowScores = showScores
            if showDialog then
                bj.CustomVictoryDialogBJ(whichPlayer)
            else
                bj.CustomVictorySkipBJ(whichPlayer)
            end
        end
    end
end
bj.AbortCinematicFadeBJ = function()
    if cg.bj_cineFadeContinueTimer ~= nil then
        cj.DestroyTimer(cg.bj_cineFadeContinueTimer)
    end

    if cg.bj_cineFadeFinishTimer ~= nil then
        cj.DestroyTimer(cg.bj_cineFadeFinishTimer)
    end
end
bj.CinematicFilterGenericBJ = function(duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    bj.AbortCinematicFadeBJ()
    cj.SetCineFilterTexture(tex)
    cj.SetCineFilterBlendMode(bmode)
    cj.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    cj.SetCineFilterStartUV(0, 0, 1, 1)
    cj.SetCineFilterEndUV(0, 0, 1, 1)
    cj.SetCineFilterStartColor(cj.PercentTo255(red0), cj.PercentTo255(green0), cj.PercentTo255(blue0), cj.PercentTo255(100 - trans0))
    cj.SetCineFilterEndColor(cj.PercentTo255(red1), cj.PercentTo255(green1), cj.PercentTo255(blue1), cj.PercentTo255(100 - trans1))
    cj.SetCineFilterDuration(duration)
    cj.DisplayCineFilter(true)
end
bj.SetUnitVertexColorBJ = function(whichUnit, red, green, blue, transparency)
    cj.SetUnitVertexColor(whichUnit, cj.PercentTo255(red), cj.PercentTo255(green), cj.PercentTo255(blue), cj.PercentTo255(100.0 - transparency))
end
bj.CreateQuestBJ = function(questType, title, description, iconPath)
    local required = questType == bj_QUESTTYPE_REQ_DISCOVERED or questType == bj_QUESTTYPE_REQ_UNDISCOVERED
    local discovered = questType == bj_QUESTTYPE_REQ_DISCOVERED or questType == bj_QUESTTYPE_OPT_DISCOVERED
    local cq = cj.CreateQuest()
    cj.QuestSetTitle(bj_lastCreatedQuest, title)
    cj.QuestSetDescription(bj_lastCreatedQuest, description)
    cj.QuestSetIconPath(bj_lastCreatedQuest, iconPath)
    cj.QuestSetRequired(bj_lastCreatedQuest, required)
    cj.QuestSetDiscovered(bj_lastCreatedQuest, discovered)
    cj.QuestSetCompleted(bj_lastCreatedQuest, false)
    return cq;
end

bj.TriggerRegisterEnterRectSimple = function(trig, r)
    local rectRegion = cj.CreateRegion()
    cj.RegionAddRect(rectRegion, r)
    return cj.TriggerRegisterEnterRegion(trig, rectRegion, nil)
end

bj.TriggerRegisterLeaveRectSimple = function(trig, r)
    local rectRegion = cj.CreateRegion()
    cj.RegionAddRect(rectRegion, r)
    return cj.TriggerRegisterLeaveRegion(trig, rectRegion, nil)
end

bj.GetCameraBoundsMapRect = function()
    return bj_mapInitialCameraBounds
end
bj.GetPlayableMapRect = function()
    return bj_mapInitialPlayableArea
end
bj.GetCurrentCameraBoundsMapRectBJ = function()
    return cj.Rect(cj.GetCameraBoundMinX(), cj.GetCameraBoundMinY(), cj.GetCameraBoundMaxX(), cj.GetCameraBoundMaxY())
end

bj_mapInitialPlayableArea = cj.Rect(cj.GetCameraBoundMinX() - cj.GetCameraMargin(CAMERA_MARGIN_LEFT), cj.GetCameraBoundMinY() - cj.GetCameraMargin(CAMERA_MARGIN_BOTTOM), cj.GetCameraBoundMaxX() + cj.GetCameraMargin(CAMERA_MARGIN_RIGHT), cj.GetCameraBoundMaxY() + cj.GetCameraMargin(CAMERA_MARGIN_TOP))
bj_mapInitialCameraBounds = bj.GetCurrentCameraBoundsMapRectBJ()

return bj
