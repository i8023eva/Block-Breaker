//
//  UIView+CGRect.h
//  新浪微博-beat
//
//  Created by lyh on 15/10/18.
//  Copyright © 2015年 lyh. All rights reserved.
/**
 *  使控件都能跳过 .frame .size .origin 的过程
 */

#import <UIKit/UIKit.h>

@interface UIView (CGRect)
#warning
/**
 *  分类只能扩展方法, 所以属性只会生成方法的声明, _x 也不会有
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end
