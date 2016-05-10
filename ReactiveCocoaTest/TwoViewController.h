//
//  TwoViewController.h
//  ReactiveCocoaTest
//
//  Created by 海玩 on 16/4/21.
//  Copyright © 2016年 haiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface TwoViewController : UIViewController

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
