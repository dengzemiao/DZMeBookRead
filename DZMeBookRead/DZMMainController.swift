//
//  DZMMainController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMMainController: DZMViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 标题
        title = "DZMeBookRead"
        
        // 简介
        let hint = UITextView()
        hint.text = "目前项目内部颜色都是随机生成,需要到 DZMReadConfigure 文件顶部打开注释代码即可正常。 \n\n即将加入功能:\n1.长按选中功能(Swift4.0版本以包含,需要优化移植过来)\n2.本地快速进入功能(马上着手写分析器加入,简单使用),\n\n网络小说问题:\n全局搜索 搜索网络小说 找到位置进行更换请求接口,滚动模式支持预加载，但是如果预加载失败就需要一个上下拉加载上下章节,这个可以自行加上,也就是上下拉加载而已。\n\n快速进入问题:\n先出整本解析,马上找时间加速补上快速进入代码。急的可参考我GitHub上的快速进入思路,自己补上先用!\n\n调试区域问题:\n可以修改 DZMReadView 的背景颜色为随机颜色查看范围,尤其是滚动模式,查看上下间距\n\n阅读背景图片平铺问题:\n可以要求美工做一份iphoneX的图就不会平铺的情况了。我这边资源有限就随便找个图做阅读背景了。"
        hint.textColor = DZM_COLOR_124_126_128
        hint.font = UIFont.systemFont(ofSize: 15)
        hint.isEditable = false
        view.addSubview(hint)
        hint.frame = CGRect.init(x: DZM_SPACE_SA_15, y: NavgationBarHeight + DZM_SPACE_SA_15, width: ScreenWidth - DZM_SPACE_SA_30, height: DZM_SPACE_SA_300)
        
        // 跳转
        let button = UIButton(type: .custom)
        button.setTitle("点击阅读", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(read), for: .touchDown)
        view.addSubview(button)
        button.frame.size = CGSize(width: DZM_SPACE_SA_100, height: DZM_SPACE_SA_100)
        button.center = CGPoint(x: view.center.x, y: ScreenHeight - DZM_SPACE_SA_150)
    }
    
    // 跳转
    @objc private func read() {
        
        MBProgressHUD.showLoading("整本解析速度慢,以后则秒进!", to: view)
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        print("解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextParser.parser(url: url) { [weak self] (readModel) in
            
            print("解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
            MBProgressHUD.hide(self?.view)
            
            if readModel == nil {
                
                MBProgressHUD.showMessage("解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
