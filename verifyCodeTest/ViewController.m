//
//  ViewController.m
//  verifyCodeTest
//
//  Created by 一枫 on 2018/12/29.
//  Copyright © 2018 BlackStar. All rights reserved.
//

#import "ViewController.h"
#import "SQShopInviteCodeView.h"

@interface ViewController ()<SQShopInviteCodeViewDelegate>

@property (nonatomic,strong) SQShopInviteCodeView *inviteCodeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn setTitle:@"输入验证码" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClick{
    
    [self.inviteCodeView showCodeView];
}

-(void)shopInviteCodeViewCode:(NSString *)codeStr rightBtnClick:(UIButton *)sender removeSelf:(void (^)(BOOL, NSString *))removeSelfBlock{
    /*
     block 说明
     第一个参数是 是否移除当前 输入框 视图
     第二个参数，提示信息
     */
    removeSelfBlock(NO,@"请输入正确验证码");
}


-(SQShopInviteCodeView *)inviteCodeView{
    if (!_inviteCodeView) {
        _inviteCodeView = [[SQShopInviteCodeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _inviteCodeView.delegate = self;
        _inviteCodeView.codeCount = 6;
    }
    return _inviteCodeView;
}

@end
