# DZMeBookRead

![Swift Version](https://img.shields.io/badge/Swift-4.0-orange.svg)
![Xcode Version](https://img.shields.io/badge/Xcode-9.2-orange.svg)
![Author](https://img.shields.io/badge/Author-DZM-blue.svg)

***
#### 语言版本

    Swift3.x - https://github.com/dengzemiao/DZMeBookRead-Swift3.x

***
#### Demo效果：

![Demo效果](gif_0.gif)

***
#### 长按效果：

![Demo效果](gif_1.gif)

***

#### 阅读打开书籍效果(已封装,使用简单,下载地址在下面):

![阅读打开书籍效果:](gif_2.gif)

***

```diff
- 推荐下自己写的:

- -> 无限滚动:
- 通常的都是传入URL数组进行无限滚动，而这个则是传入自定义的(Views)视图数组进行无限滚动，也支持控制器无限滚动
- 有兴趣的可以试试: https://github.com/dengzemiao/DZMCycleScrollView

- -> 图片展示器:
- 支持横竖屏,屏幕旋转,使用简单,注释多可扩展程度高,兼容Swift混编使用
- 有兴趣的可以试试: https://github.com/dengzemiao/DZMPhotoBrowser
```

***
#### 简介:

    2018-1-26 更新:

        更新 Swift4.0 - Xcode9.2

    2017-12-21 更新:

        支持 PageViewController (仿真模式)翻页背面内容效果

    2017-12-14 更新:
    
        添加长按放大并选中文字进行拷贝

    2017-12-14 之前更新:

        iOS11 iPhoneX 适配完成 - 有时间我会把下划线,笔记...这些常用功能加进去
    
        (为了展示更多,下载包可能有点大,因为放了下面的展示图片)

        网络小说已经在相关地方做了操作提示: 全局搜索 "网络小说操作提示"

        本Demo代码简洁注释多,方法封装可拷贝,该项目支持直接拖入项目使用

        翻页效果: 无效果,覆盖,仿真,上下滚动

        其他功能: 字体切换,书签功能,阅读记录,亮度调整,背景切换,文件解析,内容排版美观优化(多余空格回车都会进行清理),分页精确...

        背景: (网络小说获取章节地方有代码提示怎么做),仿真模式翻页背面颜色跟着主颜色变(系统默认是白色)

        定位: 阅读记录,书签,定位精确

        内存: 只要看不见的章节都会进行清理内存,不会占用内存
    
        导入项目流程 -> 请看下面的 文件介绍
        
***
#### 小说相关库：

放大镜: https://github.com/dengzemiao/DZMMagnifierView

阅读打开书籍效果: https://github.com/dengzemiao/DZMAnimatedTransitioning

小说《覆盖效果》: https://github.com/dengzemiao/DZMCoverAnimation

UIPageViewController 翻页背景颜色修改: http://www.jianshu.com/p/3e75fa22ada8

***
#### 唯一遗憾:
    上下滚动模式 飞速滑动时CPU会跟不上导致有些卡顿
    参考解决:
        1.可通过调整 tableView.decelerationRate 来进行控制。
        2.可看懂源码之后优化部分代码
***
#### 功能扩展 ( 本地阅读 快速进入 ):
    使用正则搜索出所有章节NSRange数组(本Demo就有)
    然后可解析一章(多少章自己觉定,也可以做到加载一页或几页)之后,直接跳转阅读页面
    剩余的章节则在一个异步线程中后台解析并存放到相同的路径(解析以及存储方法本Demo都有,只需找个地方进行异步解析)
    同时在解析过程中也要以防出现退出或者问题导致解析结束,那么则每解析一章都需要进行记录相关需要的数据(比如解析到第几章...)
    在异步解析过程中可能你同时也在阅读,你也可能在章节列表中随意选择一章,但是这一章还没解析到,那么你就要通过NSRange数组直接解析并存储并进入阅读
    在异步解析过程中每解析到一章你则需要判断存储文件里面是否已经有文件存在,也是避免上一步操作带来的重复解析的问题
    当解析完毕则需要设置一个BOOL值在进行记录这一本书解析完毕,一面下次在重复操作(本Demo则可以将BOOL值放入ReadModel中)
    (本Demo暂时没做这个快速进入功能,这个需要自己根据需求添加,不明白可进群咨询)

***
## 有BUG请联系我 技术QQ群:52181885 （入群需要回答问题：常用的网络请求框架? 有的QQ版本不显示问题 已经出现过这样的情况 所以入群自己填上答案就行 防止广告之类的人进入）

***
#### 文件介绍:

![文件介绍1](icon_0.png)

![文件介绍2](icon_1.png)

***
#### 部分代码浏览:

![代码浏览1](code_0.png)

![代码浏览2](code_1.png)

![代码浏览3](code_2.png)
