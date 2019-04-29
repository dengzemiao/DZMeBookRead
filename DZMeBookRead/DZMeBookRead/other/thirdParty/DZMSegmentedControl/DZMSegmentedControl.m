//
//  DZMSegmentedControl.m
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/25.
//  Copyright © 2019年 DZM. All rights reserved.
//

#import "DZMSegmentedControl.h"

@interface DZMSegmentedControl()

/// 默认字体
@property (nonatomic, strong) NSMutableArray<UIButton *> *items;

/// 滑动条
@property (nonatomic, strong) UIView *sliderView;

/// 当前选中按钮
@property (nonatomic, weak) UIButton *selectItem;

@end

@implementation DZMSegmentedControl

- (NSMutableArray<UIButton *> *)items {
    
    if (!_items) {
        
        _items = [NSMutableArray array];
    }
    
    return _items;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.normalFont = [UIFont systemFontOfSize:14];
        self.selectFont = [UIFont boldSystemFontOfSize:16];
        self.normalColor = [UIColor grayColor];
        self.selectColor = [UIColor redColor];
        self.sliderColor = [UIColor redColor];
        self.sliderHeight = 2;
        self.sliderBottom = 0;
        self.sliderWidth = DZMSegmentedControlSliderWidthFill;
        self.itemSpace = 0;
        self.sliderView = [[UIView alloc] init];
        self.insets = UIEdgeInsetsZero;
        _selectIndex = -1;
    }
    
    return self;
}

/// 刷新列表
- (void)reloadTitles:(NSArray <NSString *>*)titles {
    
    [self reloadTitles:titles index:0];
}

/// 刷新列表 并 选中指定按钮
- (void)reloadTitles:(NSArray <NSString *>*)titles index:(NSInteger)index {
    
    if (titles.count <= 0) { return ; }
    
    for (UIButton *item in self.items) {
        
        [item removeFromSuperview];
    }
    
    [self.items removeAllObjects];
    
    NSInteger count = titles.count;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        
        item.tag = i;
        
        [item setTitle:titles[i] forState:UIControlStateNormal];
        
        [item setTitle:titles[i] forState:UIControlStateSelected];
        
        [self.items addObject:item];
        
        [self addSubview:item];
        
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addSubview:self.sliderView];
    
    [self scrollIndex:index animated:NO];
    
    [self reloadUI];
}

/// 选中索引
- (void)scrollIndex:(NSInteger)index animated:(BOOL)animated {
    
    [self selectItem:index];
    
    if (_selectIndex == index) { return ; }
    
    _selectIndex = index;
    
    if (animated) {
        
        __weak DZMSegmentedControl *weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSelf.sliderView.frame = CGRectMake(weakSelf.selectItem.center.x - weakSelf.sliderView.frame.size.width / 2, weakSelf.frame.size.height - weakSelf.sliderHeight + self.sliderBottom, weakSelf.sliderView.frame.size.width, weakSelf.sliderHeight);
            
        }];
        
    }else{
        
        self.sliderView.frame = CGRectMake(self.selectItem.center.x - self.sliderView.frame.size.width / 2, self.frame.size.height - self.sliderHeight + self.sliderBottom, self.sliderView.frame.size.width, self.sliderHeight);
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedControl:scrollIndex:)]) {
        
        [self.delegate segmentedControl:self scrollIndex:index];
    }
}

/// 选中按钮
- (void)selectItem:(NSInteger)index {
    
    self.selectItem.selected = NO;
    
    self.selectItem.titleLabel.font = self.normalFont;
    
    UIButton *item = self.items[index];
    
    item.selected = YES;
    
    item.titleLabel.font = self.selectFont;
    
    self.selectItem = item;
}

/// 刷新当前页面布局
- (void)reloadUI {
    
    NSInteger count = self.items.count;
    
    if (count <= 0) { return ; }
    
    CGFloat itemX = self.insets.left;
    
    CGFloat itemY = self.insets.top;
    
    CGFloat itemW = ((self.frame.size.width - self.insets.left - self.insets.right) - ((count - 1) * self.itemSpace)) / count;
    
    CGFloat itemH = self.frame.size.height - self.insets.top - self.insets.bottom;
    
    for (int i = 0; i < count; i++) {
        
        UIButton *item = self.items[i];
        
        item.frame = CGRectMake(itemX + i * (itemW + self.itemSpace), itemY, itemW, itemH);
        
        if (item.isSelected) { item.titleLabel.font = self.selectFont;
            
        }else{ item.titleLabel.font = self.normalFont; }
        
        [item setTitleColor:self.normalColor forState:UIControlStateNormal];
        
        [item setTitleColor:self.selectColor forState:UIControlStateSelected];
    }
    
    CGFloat sliderWidth = (self.sliderWidth < 0) ? self.frame.size.width : self.sliderWidth;
    
    sliderWidth = MIN(sliderWidth, itemW);
    
    self.sliderView.backgroundColor = self.sliderColor;
    
    self.sliderView.frame = CGRectMake(self.selectItem.center.x - sliderWidth / 2, self.frame.size.height - self.sliderHeight + self.sliderBottom, sliderWidth, self.sliderHeight);
}

/// 滑动滑条
- (void)scrollSlider:(UIScrollView *)scrollView {
    
}

- (void)clickItem:(UIButton *)item {
    
    if (self.selectIndex == item.tag) { return ; }
    
    [self scrollIndex:item.tag animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(segmentedControl:clickIndex:)]) {
        
        [self.delegate segmentedControl:self clickIndex:item.tag];
    }
}

@end
