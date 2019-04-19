-- h-lua 系统提醒（F9任务）
txt = ""
txt = txt .. "h-lua完全独立，不依赖任何游戏平台（如YDWE、JAPI、DzApi * 支持使用）"
txt = txt .. "|n包含多样丰富的属性系统，可以轻松做出平时难以甚至不能做出的地图效果"
txt = txt .. "|n内置多达几十种以上的自定义事件，轻松实现神奇的主动和被动效果"
txt = txt .. "|n自带物品合成，免去自行编写的困惑。丰富的自定义技能模板"
txt = txt .. "|n镜头、单位组、过滤器、背景音乐、天气等也应有尽有"
txt = txt .. "|n想要了解更多，官方QQ群 325338043 官网教程 www.hunzsig.org"
bj.CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "h-lua",txt, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp" )
txt = ""
txt = txt .. "-random 随机选择"
txt = txt .. "|n-repick 重新选择"
bj.CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "h-lua选择英雄指令",txt, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp" )
txt = ""
txt = txt .. "-mbap 查看所有玩家统计"
txt = txt .. "|n-mbme 查看你的个人实时状态"
txt = txt .. "|n-mbsa 查看双击锁定单位的基本属性"
txt = txt .. "|n-mbse 查看双击锁定单位的特效属性"
txt = txt .. "|n-mbsn 查看双击锁定单位的自然属性"
txt = txt .. "|n-mbsi 查看双击锁定单位的物品"
txt = txt .. "|n-mbh 隐藏面板"
bj.CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "如何使用h-lua多面板",txt, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp" )
txt = ""
txt = txt .. "-apc 设定是否自动转换黄金为木头"
txt = txt .. "|n获得黄金超过100万时，自动按照比率转换多余的部分为木头"
txt = txt .. "|n如果超过时没有开启，会寄存下来，待开启再转换(上限1000万)"
bj.CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "设定自动转金为木",txt, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp" )
txt = ""
txt = txt .. "-lsr 设定生命源"
txt = txt .. "-msr 设定魔法源"
txt = txt .. "|n生命、魔法源可在当前量少于设定比例时，在 10秒 内尽可能地恢复生命或者魔法"
txt = txt .. "|n输入即可选择生命、魔法源的自动恢复触发比例 如 -lsr 10、-msr 10"
txt = txt .. "|n当源耗尽时，可以选择物品补充，而源力本身每隔 25秒 恢复 300点 能量"
bj.CreateQuestBJ( bj_QUESTTYPE_OPT_DISCOVERED, "设定生命、魔法源自动比例",txt, "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp" )