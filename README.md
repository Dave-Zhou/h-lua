# h-lua
### h-lua是在h-vjass基础上更进一步的魔兽制图框架
 * [未完成的实践：bossHunter](https://github.com/hunzsig/h-war3/tree/master/w3xMaps/bossHunter)
 * author hunzsig
 * version v2019/05/06

## 使用优势？
##### h-lua拥有优秀的demo，在开源的同时引导您学习的更多，不依赖任何游戏平台（如JAPI、DzAPI）但并不禁止你使用(有集成DzAPI)。
##### 包含多样丰富的属性系统，内置多达几十种以上的自定义事件,可以轻松做出平时难以甚至不能做出的技能效果。
##### 强大的物品合成分拆，丰富自定义技能模板！免去自行编写！
##### 镜头、单位组、过滤器、背景音乐、天气等也应有尽有。
###### 本套代码免费提供给了解lua的作者试用，如果不了解lua请自行学习，此处不提供教学

> 以下教程以YDWE为例
## 前期准备：
### 关闭YWDE的 逆天触发 
> 会使得某些原生方法胡乱添加YDWE前缀

#### 框架结构如下：
```
    |- h-lua.lua - 入口文件，你的main文件需要包含它
    |- hSlk.lua - SLK物编生成数据
    |- hSlkInit.lua - SLK物编初始化
    |- f9.lua - 框架任务
    |- blizzard_b.lua - 暴雪BJ全局
    |- blizzard_c.lua - 暴雪C全局
    |- blizzard_bj.lua - 暴雪部分BJ函数
    |- blizzard_def.lua - 实际无用，参考用途
    |- json.lua - json库
    |- lib
        |- ability - 基础技能
        |- attrbute - 基础/拓展/伤害特效/自然/单位关联，万能属性系统，比h-vjass的更加自由及强大
        |- award - 奖励模块，用于控制玩家的黄金木头经验
        |- camera - 镜头模块，用于控制玩家镜头
        |- dzapi - 一个重构dzapi的例子
        |- effect - 特效模块
        |- enemy - 敌人模块，用于设定敌人玩家，自动分配单位
        |- env - 环境模块，可随机为区域生成装饰物及地表纹理
        |- event - 事件模块，自定义事件，包括物品合成分拆/暴击，精确攻击捕捉等
        |- group - 单位组
        |- hero - 英雄/选英雄模块，包含点击/酒馆选择，repick/random功能等
        |- is - 判断模块 * 常用
        |- item - 物品模块，与属性系统无缝结合，合成/分拆等功能
        |- lightning - 闪电链
        |- logic - 逻辑模块
        |- mark - 遮罩模块
        |- media - 声音模块
        |- message - 消息模块(注意漂浮字模块与hvjass不同，是一个独立的ttg模块)
        |- multiboard - 多面板，包含自带的属性系统
        |- player - 玩家
        |- rect - 区域
        |- skill - 高级技能
        |- system - 系统默认函数
        |- time - 时间/计时器 * 常用
        |- ttg - 漂浮字模块
        |- unit - 单位
        |- weather - 天气
```
