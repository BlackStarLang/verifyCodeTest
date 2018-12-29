//
//  UIView+Common.m

//
//  Created by iS.JiAo on 2017/4/28.
//  Copyright © 2017年 Z.Jiao. All rights reserved.
//

#import "UIView+CommonUI.h"

#define CELL_TOPLINE        112301
#define CELL_BOTLINE        112302

//默认分割线的颜色
#define DEFAULT_SEPLINE_COLOR Color0xValue(0xDCDAE3)


@implementation UIView (CommonUI)

- (CGSize) size{
    return self.frame.size;
}
- (void) setSize: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint) origin{
    return self.frame.origin;
}
- (void) setOrigin: (CGPoint) aPoint{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGFloat) height{
    return self.frame.size.height;
}
- (void) setHeight: (CGFloat) newheight{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat) width{
    return self.frame.size.width;
}
- (void) setWidth: (CGFloat) newwidth{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat) right{
    return self.frame.origin.x + self.frame.size.width;
}
- (void) setRight: (CGFloat) newright{
    CGRect newframe = self.frame;
    newframe.origin.x = (newright - newframe.size.width);
    self.frame = newframe;
}

- (CGFloat) top{
    return self.frame.origin.y;
}
- (void) setTop: (CGFloat) newtop{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) bottom{
    return self.frame.origin.y+self.frame.size.height;
}
- (void) setBottom: (CGFloat) newbottom{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom-newframe.size.height;
    self.frame = newframe;
}

- (CGFloat) left{
    return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

@end
