# DZMeBookRead

![Version](https://img.shields.io/badge/Version-1.3-orange.svg)
![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)
![Xcode Version](https://img.shields.io/badge/Xcode-12.4-orange.svg)
![Author](https://img.shields.io/badge/Author-DZM-blue.svg)

***

#### 一、联系方式

#### iOS技术QQ群 ( 进群转wx群，群公告有wx群二维码 ) :  52181885 
#### 技术交流群 ( 进群转wx群，群公告有wx群二维码 ) : 942885030

***

#### 二、DEMO 效果（导入项目流程看 `第四步`）

![DEMO效果](gif_0.gif)

***

#### 三、简介与版本记录

```
提示: 

下载不同版本可在上面的 Branch 选项中选择下载版本, master 分支为最新版本。

v1.3 (Swift4.2) {

    2021-4-9 更新: 解决放大镜在 iOS 13 之后系统中长按不显示问题，iOS13 以后苹果增加了 SceneDelegate 来管理窗口，必须将自定义 Window 注册到 SceneDelegate 中。
    
    2021-4-9 更新: 优化长按弹出操作菜单代码，解决隐藏操作菜单闪动问题，更新为 Xcode 12.4
    
    2021-4-8 更新: 页尾留白问题解决，新问题：英文阅读单纯被分割，但是按单词分割，页尾则会留白，参考 DZMReadConfigure.swift 文件 242 行。
    
    2020-11-25 更新: 感谢 @dreeye 小伙伴的帮助！！修复滚动模式滚动内容崩溃问题，之前是由于存放章节字典有线程安全问题导致章节对象中途释放出现野指针崩溃，现在已经修复，滚动模式可以正常使用了。 

    2020-11-25 更新：滚动模式崩溃问题：“现在有个BUG在iOS12.2以后, iOS12.2以前到没出现，我这边测试机用的X才会系列会出现，其他机型好像也不会，滚动模式 DZMReadViewScrollController -> chapterModels 字段里面章节model会提前释放，不会被强引用，很是郁闷, 低版本没有问题。拿到Demo的可以测试一下滚动模式下会不会有问题。其实就是章节Model提前释放了,但是我存放的是字典对象，理论上是强引用对象的，现在12.2却出现这样的问题”

    2020-6-15 更新: 加入【平移翻页模式】
}

v1.2 (Swift4.2) { (同上版本)

    2019-5-20 BUG: 滚动模式在iOS12版本以上会出现闪退,原因是字典里面的章节内容对象提前释放了,iOS12以下却没有问题,暂时没有更好的存储方式所以先替换为之前版本存储方式。
    
    2019-5-17 修复: 书籍首页添加标签BUG, 第一次进入创建阅读页多次BUG。

    2019-5-16 更新: 加入TXT全本快速进入阅读。

    2020-3-17 由于系统 UIPageViewController 的点击左右翻页范围太小，且不可自由控制，增加自定义手势开关支持随意控制仿真模式左右翻页菜单的点击区域控制。
}

v1.1 (Swift4.2) { (TXT,有书籍首页)

    2019-5-16 更新: 解析文本,代码细节优化。
    
    2019-5-10 修复: 无效果快速点击BUG。
    
    2019-5-7 更新: 加入书籍首页支持。
}

v1.0 (Swift4.2) { (TXT,无书籍首页)

    2019-4-29 更新: 重做Demo, 升级Swift4.2, 解决遗留问题, 优化代码使用。
}
```

***

#### 四、导入项目流程

![文件介绍1](icon_0.png)

***

#### 五、epub 支持提示

```
DTCoreText同样也可以解析txt，epub...分页相关的功能，很方便。不需要像我这个Demo中一样复杂的解析处理。当然有喜欢研究CoreText可以参考下我的Demo。

DTCoreText对于epub来说，主要功能就是能够将我们输入的HTML文件进行解析,并自动关联相对应的css样式（也帮我们解析好了),我们需要做的就是输入一个HTML文件,

他就会给我们输出带有排版样式的NSAttributedString，然后我们直接使用CoreText进行画这个NSAttributedString就可以啦！

Github地址：https://github.com/Cocoanetics/DTCoreText
```

***

#### 六、项目思路理解：

    1. 将一个完整的TXT或者文本解析成一章一章的章节模型，通过归档的模式进行缓存起来(归档解析速度比数据库要快)。

    归档缓存方式:

        通过 bookID 和 chapterID 作为文件夹以及文件名进行缓存,

        这样做的话那么只需要面对 bookID 和 chapterID 就可以知道本地是否有这个章节存在以及获取阅读,
        
        同时在网络小说的情况下,你需要通过 bookID 和 chapterID 就在任何位置，或者后台进行缓存下载章节，并同时进行流畅阅读,
        
        只需要在阅读或者下载的时候判断下本地是否存在该章节归档文件就可以避免重复下载。
        
    2. 创建一个 readModel, readModel 里面存放的是这本小说的公用属性, 比如阅读记录, 书签, 等等...

       在阅读过程中就是起到一个针对这本小说需要公用属性以及记录属性的作用
       
       那么怎么使用它进入阅读呢？ 你只需要通过一个 bookID 获得一个 readModel 对象, 然后使用它里面修改阅读记录的方法, 
       
       将你需要阅读的章节的 chapterID 传进去修改为当前这个 readModel 的阅读记录对象即可, 你修改阅读记录的章节必须存在,
       
       也就是说你是网络小说就要先将要阅读的章节下载到本地归档好, 本地小说就先解析一章到本地归档好, 在使用 readModel 进行修改阅读记录,
       
       然后传给控制器就可以进行阅读了。
       
    3. readModel里面的 chapterListModels 是可有可无的, 阅读过程中不依赖章节列表, 也就是说你可以先设置章节列表, 也可以删除不使用,

       也可以在 DZMRMLeftView 里面去单独请求这个章节列表的数据, 它的作用只是用于手动选章节的使用得到一个 chapterID 进行加载并缓存阅读而已,
       
       一般 chapterModel 里面就已经带好了当前章节ID以及上下章章节ID。
       
    4. 网络小说使用:
        
       1).进入阅读页的时候获取一个你要阅读的 chapterID, 这个 chapterID 的章节内容需要存在本地归档文件里面, 并通过 readModel 修改为阅读记录对象,就可以传入控制器进行阅读了。
       
       2).然后在上下翻页里面根据 chapterID 判断是否有归档文件, 没有就下周并缓存, 修改为阅读记录进行继续阅读, 如果不知道在哪里修改, 全局搜索 "网络小说操作提示", 可以看注释。
       
       3).边下载边看这个操作就可以看上面 1. 的提示了。
       
       4).章节归档处理的 增删改查 都已经封装, 可以直接使用 在 DZMKeyedArchiver.swift 文件中下面。

***

#### 七、附带信息

* [OC 如何集成](https://github.com/dengzemiao/OCDZMeBookRead)

* 小说相关库或文章

    * [放大镜](https://github.com/dengzemiao/DZMMagnifierView)

    * [阅读打开书籍效果](https://github.com/dengzemiao/DZMAnimatedTransitioning)

    * [小说《覆盖效果》](https://github.com/dengzemiao/DZMCoverAnimation)

    * [UIPageViewController 翻页背景颜色修改](http://www.jianshu.com/p/3e75fa22ada8) 

* 上架APP

    * [简阅](https://apps.apple.com/cn/app/id1494994480)

    * [搜书大师](https://apps.apple.com/cn/app/id1523194349)

    * [笔趣阁](https://apps.apple.com/cn/app/id1367152987)

    * 抖音上很多小说APP都有使用或借鉴到本DEMO

* DEMO老版本

    ```
    2019-4-29 (停止更新)
    Swift4.0 - https://github.com/dengzemiao/DZMeBookRead-Swift4.0

    2018-9-6 (停止更新)
    Swift3.x - https://github.com/dengzemiao/DZMeBookRead-Swift3.x
    ```
    
* [阅读打开书籍效果](https://github.com/dengzemiao/DZMAnimatedTransitioning)

    ![阅读打开书籍效果](gif_1.gif)
