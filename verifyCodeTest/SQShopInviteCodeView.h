//
//  SQShopInviteCodeView.h
//  shequbanjing
//
//  Created by 一枫 on 2018/11/27.
//

#import <UIKit/UIKit.h>

@protocol SQShopInviteCodeViewDelegate<NSObject>

@optional

/**
 邀请码右侧按钮点击

 @param codeStr 输入的验证码
 @param sender 右侧按钮
 @param removeSelfBlock 是否移除父视图的回调
 isRemove   :是否移除
 tipStr     :邀请码输入出现错误的提示
 */
-(void)shopInviteCodeViewCode:(NSString *)codeStr rightBtnClick:(UIButton*)sender removeSelf:(void(^)(BOOL isRemove, NSString* tipStr))removeSelfBlock;

@end

@interface SQShopInviteCodeView : UIView

@property (nonatomic,weak) id <SQShopInviteCodeViewDelegate> delegate;

@property (nonatomic,strong) UITextField *codeField;                //用于输入
@property (nonatomic,strong) UIView *alphaView;                     //半透明背景

@property (nonatomic,strong) UIView *codeBgView;                    //白色背景框
@property (nonatomic,strong) UILabel *titleLabel;                   //标题-输入邀请码
@property (nonatomic,strong) UILabel *verifyDes;                    //验证信息提示

@property (nonatomic,strong) UIButton *leftBtn;                     //左侧按钮
@property (nonatomic,strong) UIButton *rightBtn;                    //右侧按钮

@property (nonatomic,assign) NSInteger codeCount;                  //邀请码位数

-(void)showCodeView;

@end

