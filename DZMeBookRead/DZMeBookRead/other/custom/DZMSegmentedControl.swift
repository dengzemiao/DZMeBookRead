//
//  DZMSegmentedControl.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/3/24.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

@objc protocol DZMSegmentedControlDelegate:NSObjectProtocol {
    
    /// 点击按钮
    @objc optional func segmentedControl(segmentedControl:DZMSegmentedControl, clickButton button:UIButton, index:NSInteger)
}

class DZMSegmentedControl: UIView {
    
    /// 代理
    weak var delegate:DZMSegmentedControlDelegate?
    
    /// 默认图片
    var normalImages = [String]()
    
    /// 选中图片
    var selectImages = [String]()
    
    /// 默认文字
    var normalTitles = [String]()
    
    /// 选中文字
    var selectTitles = [String]()
    
    /// 默认文字颜色
    var normalTitleColor:UIColor = UIColor.black
    
    /// 选中文字颜色
    var selectTitleColor:UIColor = UIColor.orange
    
    /// 字体大小
    var font:UIFont = UIFont.systemFont(ofSize: 14)
    
    /// 图片文字中间间距
    var buttonCenterSpaceW:CGFloat = 5
    
    /// 垂直分割线颜色
    var verticalSpaceLineColor:UIColor = UIColor.lightGray
    
    /// 垂直分割线宽
    var verticalSpaceLineW:CGFloat = 0.5
    
    /// 隐藏垂直分割线
    var hiddenVerticalSpaceLine:Bool = false
    
    /// 水平分割线颜色
    var horizontalSpaceLineColor:UIColor = UIColor.lightGray
    
    /// 水平分割线高
    var horizontalSpaceLineH:CGFloat = 0.5
    
    /// 隐藏水平分割线
    var hiddenHorizontalSpaceLine:Bool = false
    
    /// 水平分割线 YES:显示顶部 NO:显示底部
    var horizontalShowTB:Bool = true
    
    /// 开启点击自动进行选中取消
    var openClickSelected:Bool = true
    
    /// 开启点击只允许存在一个按钮选中
    var openClickOnlySelected:Bool = true
    
    /// 开启初始化选中
    var openInitClickSelected:Bool = true
    
    /// 当前选中的按钮 当 openClickOnlySelected = false 时则只会记录最后一次点击的索引
    var selectIndex:NSInteger = 0 {
        
        didSet{
            
            if !buttons.isEmpty && selectIndex != oldValue {
                
                clickButton(button: buttons[selectIndex])
            }
        }
    }
    
    /// 垂直分割线数组
    private var verticalSpaceLines:[UIView] = []
    
    /// 水平分割线
    private var horizontalSpaceLine:UIView?
    
    /// 按钮数组
    private(set) var buttons:[UIButton] = []
    
    /// 记录选中按钮 当 openClickOnlySelected = false 时则只会记录最后一次点击的按钮
    private(set) var selectButton:UIButton?
    
    /// 配置
    func setup() {
        
        for button in buttons {
            
            button.removeFromSuperview()
        }
        
        for spaceLine in verticalSpaceLines {
            
            spaceLine.removeFromSuperview()
        }
        
        horizontalSpaceLine?.removeFromSuperview()
        
        buttons.removeAll()
        
        verticalSpaceLines.removeAll()
        
        addSubviews()
    }
    
    /// 取消全部按钮选中状态
    func cancalButtonsSelected() {
        
        for button in buttons {
            
            button.isSelected = false
        }
    }
    
    init(_ delegate:DZMSegmentedControlDelegate? = nil) {
        
        super.init(frame: CGRect.zero)
        
        // 代理
        self.delegate = delegate
        
        // 背景颜色
        backgroundColor = UIColor.white
    }
    
    /// 创建子控件
    private func addSubviews() {
        
        // 数量
        let count = max(normalTitles.count, normalImages.count)
        
        // 创建
        for i in 0..<count {
            
            let button:UIButton = UIButton(type: .custom)
            
            button.tag = i
            
            if !normalTitles.isEmpty || !selectTitles.isEmpty {
                
                button.titleLabel?.font = font
            }
            
            if !normalImages.isEmpty && !normalTitles.isEmpty {
                
                button.titleEdgeInsets = UIEdgeInsetsMake(0, buttonCenterSpaceW, 0, 0)
            }
            
            if !normalTitles.isEmpty {
                
                button.setTitle(normalTitles[i], for: .normal)
                
                button.setTitleColor(normalTitleColor, for: .normal)
            }
            
            if !selectTitles.isEmpty {
                
                button.setTitle(selectTitles[i], for: .selected)
                
                button.setTitleColor(selectTitleColor, for: .selected)
            }
            
            if !normalImages.isEmpty {
                
                button.setImage(UIImage(named: normalImages[i]), for: .normal)
            }
            
            if !selectImages.isEmpty {
                
                button.setImage(UIImage(named: selectImages[i]), for: .selected)
            }
            
            button.addTarget(self, action: #selector(DZMSegmentedControl.clickButton(button:)), for: .touchDown)
            
            addSubview(button)
            
            buttons.append(button)
        }
        
        // 分割线
        if !hiddenVerticalSpaceLine && !buttons.isEmpty {
            
            let count = buttons.count - 1
            
            for _ in 0..<count {
                
                let spaceLine = SpaceLineSetup(view: self, color: verticalSpaceLineColor)
                
                addSubview(spaceLine)
                
                verticalSpaceLines.append(spaceLine)
            }
        }
        
        if !hiddenHorizontalSpaceLine {
            
            horizontalSpaceLine = SpaceLineSetup(view: self, color: horizontalSpaceLineColor)
        }
        
        // 选中按钮
        if !buttons.isEmpty && openInitClickSelected {clickButton(button: buttons[selectIndex])}
        
        // 布局
        setNeedsLayout()
    }
    
    /// 点击按钮
    @objc private func clickButton(button:UIButton) {
        
        if openClickSelected {

            if openClickOnlySelected {
                
                if selectButton == button {return}
                
                selectButton?.isSelected = false
            }
            
            button.isSelected = !button.isSelected
            
            selectButton = button
        }
        
        selectIndex = button.tag
        
        delegate?.segmentedControl?(segmentedControl: self, clickButton: button, index: selectIndex)
    }
    
    // 布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if !buttons.isEmpty {
            
            // 数量
            let count = buttons.count
            
            // 按钮宽
            var buttonW:CGFloat = width / CGFloat(count)
            
            // 按钮高
            var buttonH:CGFloat = height
            
            // 按钮Y
            var buttonY:CGFloat = horizontalSpaceLineH
            
            // 隐藏垂直分割线
            if !hiddenVerticalSpaceLine {
                
                buttonW = (width - CGFloat(count - 1) * verticalSpaceLineW) / CGFloat(count)
            }
            
            // 隐藏水平分割线
            if !hiddenHorizontalSpaceLine {
                
                buttonH -= horizontalSpaceLineH
                
                // 分割线显示到底部
                if !horizontalShowTB {
                    
                    buttonY = 0
                }
            }
            
            // 布局按钮
            for i in 0..<count {
                
                let button:UIButton = buttons[i]
                
                button.frame = CGRect(x: CGFloat(i) * (buttonW + verticalSpaceLineW), y: buttonY, width: buttonW, height: buttonH)
            }
            
            // 布局垂直分割线
            if !hiddenVerticalSpaceLine {
                
                for i in 0..<verticalSpaceLines.count {
                    
                    let spaceLine = verticalSpaceLines[i]
                    
                    spaceLine.frame = CGRect(x: buttonW + CGFloat(i) * (buttonW + verticalSpaceLineW), y: buttonY, width: verticalSpaceLineW, height: buttonH)
                }
            }
            
            // 布局水平分割线
            if !hiddenHorizontalSpaceLine {
                
                if horizontalShowTB {
                    
                    horizontalSpaceLine?.frame = CGRect(x: 0, y: 0, width: width, height: horizontalSpaceLineH)
                    
                }else{
                    
                    horizontalSpaceLine?.frame = CGRect(x: 0, y: height - horizontalSpaceLineH, width: width, height: horizontalSpaceLineH)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
