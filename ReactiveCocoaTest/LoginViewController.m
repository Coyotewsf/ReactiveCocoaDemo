//
//  LoginViewController.m
//  ReactiveCocoaTest
//
//  Created by 海玩 on 16/4/21.
//  Copyright © 2016年 haiwan. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/RACReturnSignal.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self testFlatternMap];
    //[self testTake];
    [self testTakeLast];
    //[self setUpViews];
}


- (void)setUpViews {
    UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 335, 40)];
    usernameTextField.placeholder = @"用户名";
    usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:usernameTextField];
    [[usernameTextField.rac_textSignal
      map:^id(NSString *text) {
          return [self isValidSearchText:text] ? [UIColor whiteColor] : [UIColor yellowColor];
      }]
     subscribeNext:^(UIColor *color) {
         usernameTextField.backgroundColor = color;
     }];
    
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 160, 335, 40)];
    passwordTextField.placeholder = @"密码";
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:passwordTextField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.backgroundColor = [UIColor redColor];
    btn.enabled = NO;
    btn.frame = CGRectMake(20, 220, 335, 40);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了登录按钮");
    }];
    
    //RAC(passwordTextField, text) = RACObserve(usernameTextField, text);
    
//    [[passwordTextField.rac_textSignal filter:^BOOL(NSString *value) {
//        NSLog(@"%@",value);
//        return value.length > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//
//    [[passwordTextField.rac_textSignal ignore:@"1"] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
////
//    [[passwordTextField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
//
    [passwordTextField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
//
//    [[passwordTextField.rac_textSignal skip:1] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
//    
//    
//    
//    
//    
//    
//    
//    
//    [[usernameTextField.rac_textSignal flattenMap:^RACStream *(id value) {
//        
//        // block什么时候 : 源信号发出的时候，就会调用这个block。
//        
//        // block作用 : 改变源信号的内容。
//        
//        // 返回值：绑定信号的内容.
//        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
//        
//    }] subscribeNext:^(id x) {
//        
//        // 订阅绑定信号，每当源信号发送内容，做完处理，就会调用这个block。
//        
//        NSLog(@"%@",x);
//        
//    }];
//    
//    
//    
//    RAC(btn, enabled) = [RACSignal combineLatest:@[
//                                                   usernameTextField.rac_textSignal,
//                                                   passwordTextField.rac_textSignal
//                                                   ] reduce:^(NSString *username, NSString *password) {
//                                                       return @(username.length > 0 && password.length > 0);
//                                                   }];
//    
//    [RACObserve(btn, enabled) subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];

}

- (void)testTake {
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendNext:@3];
}

- (void)testTakeLast {
    // 1、创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendCompleted];
}

- (void)testFlatternMap {
    // 创建信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    [[[signalOfsignals flattenMap:^RACStream *(id value) {
        
        // 当signalOfsignals的signals发出信号才会调用
        
        return value;
        
    }] map:^id(id value){
        NSLog(@"%@map:aaa",value);
      if([@1 isEqual: value]) {
          NSLog(@"sdfsfs");
          return @"class 1";
      } else {
          return @"class N";
      }
//        return [value isKindOfClass:[NSString class]]?@2:@3;
      
    }] subscribeNext:^(id x) {
        
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        
        NSLog(@"%@aaa",x);
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];
    
    // 信号发送内容
    [signal sendNext:@1];
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
