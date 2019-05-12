hRuntime = {
    system = {},
    logic = {},
    time = {},
    is = {},
    message = {},
    sound = {},
    mark = {},
    effect = {},
    lightning = {},
    weather = {},
    env = {},
    camera = {},
    event = {},
    eventTgr = {},
    eventGlobalTgr = {},
    textTag = {},
    rect = {},
    player = {},
    award = {},
    unit = {},
    enemy = {},
    group = {},
    hero = {},
    heroBuildSelection = {},
    skill = {},
    attribute = {},
    attributeGroup = {
        life_back = {},
        mana_back = {},
        life_source = {},
        mana_source = {},
        punish = {},
        punish_current = {},
    },
}

for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
    local p = cj.Player(i - 1)
    -- is
    hRuntime.is[p] = {}
    hRuntime.is[p].isComputer = true
    hRuntime.is[p].isAutoConvertGoldLumber = true
    -- sound
    hRuntime.sound[p] = {}
    hRuntime.sound[p].currentBgm = nil
    hRuntime.sound[p].bgmDelay = 3.00
    -- camera
    hRuntime.camera[p] = {}
    hRuntime.camera[p].model = "normal" -- 镜头模型
    hRuntime.camera[p].isShocking = false
end
