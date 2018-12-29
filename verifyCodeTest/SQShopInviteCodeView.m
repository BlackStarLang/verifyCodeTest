//
//  SQShopInviteCodeView.m
//  shequbanjing
//
//  Created by 一枫 on 2018/11/27.
//

#import "SQShopInviteCodeView.h"
#import <Masonry.h>
#import "UIView+CommonUI.h"
#import "UIColor+Category.h"

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds]).size.height
#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds]).size.width

@interface SQShopInviteCodeView ()<UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray* textFieldArr;      //输入框数组
@property (nonatomic,strong) UIButton* responsBtn;              //唤起输入框按钮

@end

@implementation SQShopInviteCodeView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initSubViews];
        [self masonryLayout];
    }
    return self;
}

- (void)initSubViews{
    [self addSubview:self.alphaView];
    [self addSubview:self.codeBgView];
    
    [self.codeBgView addSubview:self.titleLabel];
    [self.codeBgView addSubview:self.responsBtn];
    [self.codeBgView addSubview:self.verifyDes];
    [self.codeBgView addSubview:self.leftBtn];
    [self.codeBgView addSubview:self.rightBtn];
}

- (void)masonryLayout{
    
    [self.alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    self.codeBgView.frame = CGRectMake(33, 0, SCREEN_WIDTH - 66, 179);
    self.codeBgView.centerY = self.centerY;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.right.offset(0);
        make.height.mas_equalTo(24);
    }];
    
    [self.responsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.left.right.offset(0);
        make.height.mas_equalTo(33);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.left.offset(25);
        make.bottom.offset(-15);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(34);
        make.right.offset(-25);
        make.left.equalTo(self.leftBtn.mas_right).offset(20);
        make.bottom.equalTo(self.leftBtn);
        make.width.equalTo(self.leftBtn);
    }];
    
    [self.verifyDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(6);
        make.bottom.equalTo(self.leftBtn.mas_top).offset(-14);
        make.right.offset(-6);
        make.height.mas_equalTo(14);
    }];
    
}

-(void)setCodeCount:(NSInteger)codeCount{
    
    if (codeCount<=0) return;
    
    [self.textFieldArr removeAllObjects];
    
    //每个输入框的间距
    CGFloat leftMargin = (SCREEN_WIDTH - 66 - 12 - 33*codeCount)/(codeCount - 1);
    
    for (int i = 0; i<codeCount; i++) {
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(6+(33 + leftMargin)*i, 65, 33, 33)];
        textField.tag = i;
        textField.textAlignment = 1;
        textField.font = [UIFont systemFontOfSize:20];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textFieldTextChanged:) forControlEvents:UIControlEventEditingChanged];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, 33, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"DADADA"];
        [textField addSubview:line];
        
        [self.textFieldArr addObject:textField];
        
        [self.codeBgView addSubview:textField];
    }
    [self.codeBgView bringSubviewToFront:self.responsBtn];
}


-(void)showCodeView{

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    for (UITextField*tf in self.textFieldArr) {
        tf.text = @"";
    }
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    //唤起键盘
    [self responsBtnClick];
}

-(void)textFieldTextChanged:(UITextField*)textField{

    /*
     如果当前输入框是最后一个，那么在此输入不应该执行其他操作，
     保留第一个字符，然后取消键盘
     */
    if (textField.tag == self.textFieldArr.count-1 && textField.text.length>0) {
        textField.text = [textField.text substringToIndex:1];
        [self endEditing:YES];
        return;
    }
    
    self.verifyDes.text = @"";

    
    if (![textField.text isEqualToString:@""]) {

        //去除空格、回车等字符
        NSString *codeNum = [[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        if (codeNum.length<=0){
            textField.text = @"";
            return;
        }
        
        //如果字符是粘过来的 或者 连拼 输入多个字符
        if (codeNum.length>1) {
            //字符长度 没有控件多，则将下一个UITextField 唤起输入
            if (textField.text.length<self.textFieldArr.count) {
                UITextField *nextTF = self.textFieldArr[textField.text.length];
                [nextTF becomeFirstResponder];
            }else{
                [self endEditing:YES];
            }
            
            /*
             如果输入了一两个，然后粘贴，应该记住，粘贴的内容是从下标0开始的
             startNum 是当前应该 输入的 控件下标，如果当前控件的text.length>0
             则取下一位
             */
            NSInteger startNum = 0;
            
            textField.text = @"";
            for (int i = 0; i<MIN(codeNum.length, self.textFieldArr.count); i++) {
                UITextField *tf = self.textFieldArr[i];
                if (tf.text.length<=0) {
                    NSString *code = [codeNum substringWithRange:NSMakeRange(i - startNum, 1)];
                    tf.text = code;
                }else{
                    startNum = tf.tag + 1;
                }
               
            }
        }else{
            /*
             正常一个一个输入
             */
            if (textField.tag<self.textFieldArr.count - 1) {
                UITextField *nextTF = self.textFieldArr[textField.tag + 1];
                [nextTF becomeFirstResponder];
            }
        }
    }
}

#pragma mark action

-(void)leftBtnClick{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)rightBtnClick{
    
    NSMutableArray *codes = [NSMutableArray array];
    for (UITextField *textField in self.textFieldArr) {
        if (textField.text.length<=0) {
            self.verifyDes.text = @"请输入正确邀请码";
            return;
        }
        [codes addObject:textField.text];
    }
    
    NSString *codestr = [codes componentsJoinedByString:@""];
    
    if ([self.delegate respondsToSelector:@selector(shopInviteCodeViewCode:rightBtnClick:removeSelf:)]) {
        [self.delegate shopInviteCodeViewCode:codestr rightBtnClick:self.rightBtn removeSelf:^(BOOL isRemove, NSString *tipStr) {
            if (isRemove) {
                [self leftBtnClick];
            }else{
                self.verifyDes.text = tipStr;
            }
        }];
    }
}

-(void)responsBtnClick{
    
    self.verifyDes.text = @"";
    //找到正确的 响应 输入框控件，然后注册响应者,
    //如果是最后一个，即便有字符，依然响应
    for (UITextField*textF in self.textFieldArr) {
        if (textF.text.length<=0) {
            [textF becomeFirstResponder];
            break;
        }
        if (textF.tag == self.textFieldArr.count-1) {
            [textF becomeFirstResponder];
        }
    }
}


#pragma mark delegate


//当键盘出现
- (void)keyBoardWillShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.codeBgView.centerY = SCREEN_HEIGHT - keyboardHeight - 140;
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    //获取键盘的高度
    [UIView animateWithDuration:0.2 animations:^{
        self.codeBgView.centerY = SCREEN_HEIGHT/2;
    }];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    /*
     删除处理:textField.text 控件上一次显示的值，string 是本次输入的值，
     如果上一次值没有，本次又输入空字符，则为删除
     */
    if (textField.text.length<=0 && string.length<=0 && textField.tag!=0) {
        UITextField *textF = self.textFieldArr[textField.tag - 1];
        [textF becomeFirstResponder];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return NO;
}

#pragma mark 属性初始化

-(UITextField *)codeField{
    if (!_codeField) {
        _codeField = [[UITextField alloc]init];
        _codeField.delegate = self;
    }
    return _codeField;
}

-(UIView *)alphaView{
    if (!_alphaView) {
        _alphaView = [[UIView alloc]init];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.5;
    }
    return _alphaView;
}

-(UIView *)codeBgView{
    if (!_codeBgView) {
        _codeBgView = [[UIView alloc]init];
        _codeBgView.layer.cornerRadius = 4;
        _codeBgView.layer.masksToBounds = YES;
        _codeBgView.backgroundColor = [UIColor whiteColor];
    }
    return _codeBgView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = 1;
        _titleLabel.text = @"输入邀请码";
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

-(UILabel *)verifyDes{
    if (!_verifyDes) {
        _verifyDes = [[UILabel alloc]init];
        _verifyDes.font = [UIFont systemFontOfSize:10];
        _verifyDes.textColor = [UIColor colorWithHexString:@"FA3E3E"];
    }
    return _verifyDes;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc]init];
        _leftBtn.layer.cornerRadius = 2;
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.borderColor = [UIColor colorWithHexString:@"D4D4D4"].CGColor;
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        _rightBtn.layer.cornerRadius = 2;
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"29c985"];
        [_rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

-(NSMutableArray *)textFieldArr{
    if (!_textFieldArr) {
        _textFieldArr = [NSMutableArray array];
    }
    return _textFieldArr;
}

-(UIButton *)responsBtn{
    if (!_responsBtn) {
        _responsBtn = [[UIButton alloc]init];
        [_responsBtn addTarget:self action:@selector(responsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _responsBtn;
}

@end
