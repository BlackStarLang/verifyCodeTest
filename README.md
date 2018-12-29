# verifyCodeTest
常见方块验证码输入框，支持光标显示

<img src = "https://github.com/BlackStarLang/verifyCodeTest/blob/master/1.png" width = 300> <img src = "https://github.com/BlackStarLang/verifyCodeTest/blob/master/2.png" width = 300>
<img src = "https://github.com/BlackStarLang/verifyCodeTest/blob/master/3.gif" width = 300>

usage
```
-(SQShopInviteCodeView *)inviteCodeView{
    if (!_inviteCodeView) {
        _inviteCodeView = [[SQShopInviteCodeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _inviteCodeView.delegate = self;
        //验证码位数
        _inviteCodeView.codeCount = 6;
    }
    return _inviteCodeView;
}

//view delegate
-(void)shopInviteCodeViewCode:(NSString *)codeStr rightBtnClick:(UIButton *)sender removeSelf:(void (^)(BOOL, NSString *))removeSelfBlock{
    /*
     codeStr是输入的验证码
    
     block 说明
     第一个参数是 是否移除当前 输入框 视图
     第二个参数，提示信息
     */
    removeSelfBlock(NO,@"请输入正确验证码");
}
```
