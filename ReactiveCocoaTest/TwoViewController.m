//
//  TwoViewController.m
//  ReactiveCocoaTest
//
//  Created by 海玩 on 16/4/21.
//  Copyright © 2016年 haiwan. All rights reserved.
//

#import "TwoViewController.h"
#import "RedView.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"aaaaaa" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 50, 100, 30);
    
    //代替监听事件
    //btn addTarget:<#(nullable id)#> action:(nonnull SEL) forControlEvents:<#(UIControlEvents)#>
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 335, 30)];
    textField.backgroundColor = [UIColor greenColor];
    [self.view addSubview:textField];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 335, 30)];
    l.textColor = [UIColor redColor];
    l.backgroundColor = [UIColor blueColor];
    [self.view addSubview:l];
    
    //代替通知
    //[NSNotificationCenter defaultCenter] addObserver:<#(nonnull id)#> selector:<#(nonnull SEL)#> name:<#(nullable NSString *)#> object:<#(nullable id)#>
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    //以前是代理方法
    // 5.监听文本框的文字改变
    [textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    RAC(l,text) = textField.rac_textSignal;
    
    [RACObserve(l, text) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    //代替代理
    RedView *redView = [[RedView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    [self.view addSubview:redView];
    [[redView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    
    
    //代替KVO
    [[redView rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    
    [self test];
}

- (void)test {
    // 处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}


- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:nil];
    }
    
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
