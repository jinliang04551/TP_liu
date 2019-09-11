//
//  MISAppStyle.m
//  edua
//
//  Created by Mao on 9/6/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import "MISAppStyle.h"

//UIStyle

#define kNavigationBarBackgroundImage               IMAGE_WITH_NAME(@"nav_bg")
#define kNavigationBarTextShadowColor               BLACK_COLOR
#define kNavigationBarTextColor                     BLACK_COLOR
#define kNavigationBarTextFont                      NFont(20.0f)
#define kSwitchOnTintColor                          UIColorFromRGB(0xff952b)


//登录界面下面提示button
#define MISLoginNoteButtonTitleFont  NFont(15.0f);
#define MISLoginNoteButtonTitleColor BLACK_COLOR
#define MISLoginNoteButtonTitleHLColor GRAY_COLOR

@implementation MISAppStyle

+ (void)setupStyle {
	//Tab栏--TabItem
	NSShadow *shadow = [[NSShadow alloc] init];
	shadow.shadowColor = CLEAR_COLOR;
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kTabBarItemTextSelectedColor,
//                                                        NSShadowAttributeName: shadow} forState:UIControlStateSelected];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kTabBarItemTextNormalColor,
//                                                        NSShadowAttributeName:shadow} forState:UIControlStateNormal];

	//导航栏
	shadow.shadowColor = kNavigationBarTextShadowColor;
    
    [[UINavigationBar appearance] setBackgroundImage:[MISAppStyle buttonImageFromColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    
	[[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : kNavigationBarTextColor,
														   /*NSShadowAttributeName: shadow,*/
														   NSFontAttributeName : kNavigationBarTextFont
                                                           }];
    
	[UINavigationBar appearance].tintColor = BLACK_COLOR;
    
    
//    if (@available(iOS 11.0, *)) {
//
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
//
//        UIImage *backButtonImage = [[UIImage imageNamed:@"nav_btn_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//
//        [UINavigationBar appearance].backIndicatorImage = backButtonImage;
//
//        [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButtonImage;
//
//    }else{
//
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
//
//        UIImage *image = [[UIImage imageNamed:@"nav_btn_back"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
//
//        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    }
//
    

	//TableView
	[UITableView appearance].sectionIndexBackgroundColor = CLEAR_COLOR;
	[UITableView appearance].sectionIndexTrackingBackgroundColor = CLEAR_COLOR;
	[UITableView appearance].sectionIndexColor = [UIColor grayColor];
	
	//Swith
	[UISwitch appearance].onTintColor = kSwitchOnTintColor;

//    UIImage* backBgImage = [IMAGE_WITH_NAME(@"nav_btn_back") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBgImage
//                                                      forState:UIControlStateNormal
//                                                    barMetrics:UIBarMetricsDefault];
}

//通过颜色来生成一个纯色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/**
 *  登出 红包button
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)logoutBtnWithTarget:(id)target
								 action:(SEL)action
								  title:(NSString *)title {
	UIButton* btn = [UIButton autoLayoutButton];
	btn.clipsToBounds = YES;
	btn.layer.cornerRadius = 5.0f;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xEF732A)] forState:UIControlStateNormal];
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
	btn.titleLabel.font = BFont(16.0f);
	
	return btn;
}


/**
 *  登录短button
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)loginBtnWithTarget:(id)target
						  action:(SEL)action
						   title:(NSString *)title {
	UIButton* btn = [UIButton autoLayoutButton];
	btn.clipsToBounds = YES;
	btn.layer.cornerRadius = 45.0f / 2.0f;
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setBackgroundImage:[UIImage imageWithColor:[self mainOringeColor]] forState:UIControlStateNormal];
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
	btn.titleLabel.font = BFont(16.0f);
	
	return btn;
}

/**
 *  登录短button size
 *  @return UIButton
 */
+ (CGSize)loginBtnSize {
	return CGSizeMake(140.0f, 45.0f);
}


/**
 *  登录-注册 黑色提示button
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)loginNoteButtonWithTarget:(id)target
								 action:(SEL)action
								  title:(NSString *)title {
	UIButton* btn = [UIButton autoLayoutButton];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
	[btn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateHighlighted];
	btn.titleLabel.font = MISLoginNoteButtonTitleFont;
	return btn;
}

/**
 * 主题黑色
 */
+ (UIColor *)mainBlackColor {
	return UIColorFromRGB(0x31363B);
}

/**
 * 主题橙色
 */
+ (UIColor *)mainOringeColor {
	return UIColorFromRGB(0xEE732A);
}

+ (UIColor *)backgroundViewWhiteColor {
    return UIColorFromRGB(0Xedf2f6);
}

+ (UIColor *)backgroundViewGrayColor {
    return UIColorFromRGB(0xF9F9F9);
}

+ (UIColor *)borderGrayColor {
    return UIColorFromRGB(0xECECEC);
}

+ (UIColor *)mainBlueColor {
    return RGBA(39, 88, 228,1);
}

+ (UIColor *)mainGrayColor {
    return UIColorFromRGB(0xc0c3ca);
}

/**
 *  通用 底部橙色button 样式
 *
 *  @param target target
 *  @param action action
 *  @param title  title
 *
 *  @return UIButton
 */
+ (UIButton *)bottomOringeBtnWithTarget:(id)target
								 action:(SEL)action
								  title:(NSString *)title {
	UIButton* btn = [UIButton autoLayoutButton];
	[btn setTitle:title forState:UIControlStateNormal];
	[btn setBackgroundImage:[UIImage imageWithColor:[self mainOringeColor]] forState:UIControlStateNormal];
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	[btn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
	btn.titleLabel.font = BFont(16.0f);
	return btn;
}


/**
 *  登录短button size
 *  @return UIButton
 */
+ (CGSize)bottomOringeBtnSize {
	return CGSizeMake(VIEW_WIDTH, 44.0f);
}

/**
 * 通用分割线颜色
 */
+ (UIColor *)separateLineColor {
	return UIColorFromRGB(0xE3E3E3);
}


+ (UIBarButtonItem *)navigationButtonWithTitle:(NSString* )title
										target:(id)target
										action:(SEL)action {
	return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}


+ (UIBarButtonItem *)navigationButtonWithImage:(UIImage *)image
										target:(id)target
										action:(SEL)action {
	UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
	btn.clipsToBounds = YES;
	btn.layer.cornerRadius = 15.0f;
	[btn setImage:image forState:UIControlStateNormal];
	[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	return [[UIBarButtonItem alloc] initWithCustomView:btn];
}



@end

