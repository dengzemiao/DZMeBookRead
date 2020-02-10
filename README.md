# DZMeBookRead

![Version](https://img.shields.io/badge/Version-1.3-orange.svg)
![Swift Version](https://img.shields.io/badge/Swift-4.2-orange.svg)
![Xcode Version](https://img.shields.io/badge/Xcode-10.2-orange.svg)
![Author](https://img.shields.io/badge/Author-DZM-blue.svg)

***

#### OC如何集成本DEMO

    示例:  https://github.com/dengzemiao/OCDZMeBookRead

***

#### DEMO效果：

![DEMO效果](gif_0.gif)

***

#### Swift4.0 版本效果(下载地址在底部)：

![DEMO效果](gif_1.gif)

***

#### 简介:

    提示: 导入项目流程 - 往下滚动
    
    下载不同版本可在上面的 Branch 选项中选择下载版本。
    
    v1.2 (Swift4.2) { (TXT,有书籍首页)
    
        2019-5-20 BUG: 滚动模式在iOS12版本以上会出现闪退,原因是字典里面的章节内容对象提前释放了,iOS12以下却没有问题,暂时没有更好的存储方式准备先替换为v1.3版本存储方式。
        
        2019-5-17 修复: 书籍首页添加标签BUG, 第一次进入创建阅读页多次BUG。
    
        2019-5-16 更新: 加入TXT全本快速进入阅读。
    }
    
    v1.1 (Swift4.2) { (TXT,有书籍首页)
    
        2019-5-16 更新: 解析文本,代码细节优化。
        
        2019-5-10 修复: 无效果快速点击BUG。
        
        2019-5-7 更新: 加入书籍首页支持。
    }
    
    v1.0 (Swift4.2) { (TXT,无书籍首页)
    
        2019-4-29 更新: 重做Demo, 升级Swift4.2, 解决遗留问题, 优化代码使用。
    }
    
***

#### 小说相关库：

    放大镜: https://github.com/dengzemiao/DZMMagnifierView

    阅读打开书籍效果: https://github.com/dengzemiao/DZMAnimatedTransitioning

    小说《覆盖效果》: https://github.com/dengzemiao/DZMCoverAnimation

    UIPageViewController 翻页背景颜色修改: http://www.jianshu.com/p/3e75fa22ada8

***

#### 上架APP：

* [简阅](https://apps.apple.com/cn/app/%E7%AE%80%E9%98%85-%E5%81%9A%E6%9C%80%E5%A5%BD%E7%9A%84%E5%B0%8F%E8%AF%B4%E9%98%85%E8%AF%BB%E8%BD%AF%E4%BB%B6/id1494994480)

***

#### 导入项目流程:

![文件介绍1](icon_0.png)

***

### 有BUG请联系我 技术QQ群: （入群需要回答问题：写一句让APP崩溃的代码? 有的QQ版本不显示问题 已经出现过这样的情况 所以入群自己填上答案就行 防止广告之类的人进入）
### 52181885 (已满)
### 942885030 (新群)

***

#### epub提示

    DTCoreText同样也可以解析txt，epub...分页相关的功能，很方便。不需要像我这个Demo中一样复杂的解析处理。当然有喜欢研究CoreText可以参考下我的Demo。

    DTCoreText对于epub来说，主要功能就是能够将我们输入的HTML文件进行解析,并自动关联相对应的css样式（也帮我们解析好了),我们需要做的就是输入一个HTML文件,

    他就会给我们输出带有排版样式的NSAttributedString，然后我们直接使用CoreText进行画这个NSAttributedString就可以啦！

    Github地址：https://github.com/Cocoanetics/DTCoreText

***

#### 功能扩展 ( 本地阅读 快速进入 ):

    快速进入做法(我这里列2种):

    1.【这种适用于所有文章使用】单独写一个快速进入的解析器,先解析第一章(或者第一页,数值自己控制)出来进行使用.其他后台线程解析获取。
        
        通过正则先搜索出来一个章节进行阅读,其他剩下的则再次通过DEMO里面给与的正则搜索获得文章的所有章节位置ranges
        
        然后取出第一个range进行解析进入阅读,其他的后台解析读取,每次解析一个章节时需要检查本地是否存在
        
        这样就可以在阅读过程中,可能随意点击一个没有解析到的章节
        
        直接优先解析出来进行阅读,且还可以像网络数据一样预加载前后章节,相当于解析器里面存的就是服务器数据
        
        你只是在获取回来使用而已。这样也不会出现重复解析章节的情况。
    
    2.【这种适用中小文章使用,原因是大文章查询以及解析久】直接全部解析成章节内容列表放在内存中使用, 一般不是天大的章节数目内存还是够用的。

***

#### DEMO老版本

    2019-4-29 (停止更新)
    Swift4.0 - https://github.com/dengzemiao/DZMeBookRead-Swift4.0

    2018-9-6 (停止更新)
    Swift3.x - https://github.com/dengzemiao/DZMeBookRead-Swift3.x

