-- 加载YDWE本体库
cj = require "jass.common"
cmsg = require "jass.message"
cg = require "jass.globals"
japi = require "jass.japi"

-- 加载blizzard
require "foundation.blizzard_c"
require "foundation.blizzard_b"
bj = require "foundation.blizzard_bj"

-- 加载json
json = require "foundation.json"

-- 加载runtime
require "foundation.runtime"

-- 读取hSlk数据 # hash_hslk
hsystem = require "lib.system"
require "slkInit"
require "foundation.f9"

--[[
    加载Dzapi库
    需要网易魔兽官网平台支持
    如果在lua中无法找到Dzapi，你需要检查下面的部分：
    1. YDWE——配置——魔兽插件——[勾上]LUA引擎（不行就做第2步）
    2. 打开触发窗口（F4），创建一个不运行的触发（无事件），在条件及动作补充你需要的Dzapi
]]
hdzapi = require "lib.dzapi"

-- 加载h-lua库
hlogic = require "lib.logic" -- 逻辑
htime = require "lib.time" -- 时间/计时器
his = require "lib.is" -- 条件判断
hmsg = require "lib.message" -- 消息
hsound = require "lib.sound" -- 多媒体
hmark = require "lib.mark" -- 遮罩
heffect = require "lib.effect" -- 特效
hlightning = require "lib.lightning" -- 闪电链
hweather = require "lib.weather" -- 天气
henv = require "lib.env" -- 环境装饰
hcamera = require "lib.camera" -- 镜头
hevent = require "lib.event" -- 事件
httg = require "lib.textTag" -- 漂浮字
hrect = require "lib.rect" -- 区域
hplayer = require "lib.player" -- 玩家
haward = require "lib.award" -- 奖励
hunit = require "lib.unit" -- 单位
hemeny = require "lib.enemy" -- 敌人
hgroup = require "lib.group" -- 单位组
hhero = require "lib.hero" -- 英雄
hskill = require "lib.skill" -- 技能
hattr = require "lib.attribute" -- 属性

-- 最后的初始化
-- last init
require "foundation.start"


