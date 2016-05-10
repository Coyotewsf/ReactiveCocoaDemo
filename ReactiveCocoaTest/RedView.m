//
//  RedView.m
//  ReactiveCocoaTest
//
//  Created by 海玩 on 16/4/21.
//  Copyright © 2016年 haiwan. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor redColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, self.frame.size.width, 40);
        [btn setTitle:@"按钮" forState:UIControlStateNormal];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    self.center = CGPointMake(self.center.x, self.center.y+10);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
