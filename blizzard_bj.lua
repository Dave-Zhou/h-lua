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
bj.TriggerRegisterPlayerSelectionEvent = function(trig, whichPlayer, selected)
    if (selected) then
        return cj.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_SELECTED, nil)
    else
        return cj.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, EVENT_PLAYER_UNIT_DESELECTED, nil)
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

return bj
