//
//  Header.h
//  TP_liu
//
//  Created by liu on 2018/7/12.
//  Copyright © 2018年 liu. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import<Foundation/Foundation.h>

/*
 *  0:正式环境 1:测试环境
 */
#define MIS_DEBUG 0

/*
 *  0:正式环境 1:测试环境
 */
#define OPEN_LOG 1

/*
 *  0:正式环境 1:测试环境
 */
#define MIS_BAND_DATA_SIMULATOR 0

/*
 *  1:正式环境 0:测试环境
 */
#define UMENG_ON 1

#define VERSION_NUMBER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define AppHelloPageShowedState @"AppHelloPageShowedState"  //欢迎页是否显示状态
#define AppGuidePageShowedState @"GuidePageHasShowed"       //引导页是否显示状态
#define UMENG_APP_KEY           @"5b052318a40fa363770001d8" //友盟

#define MISUnBandWatchSuccessNotification @"unBandWatchSuccessNotification"

#define MIS_ZTB_BIND_MAC    @"ztb_bind_mac"

// 只要添加了这个宏，就不用带mas_前缀
#define MAS_SHORTHAND
// 只要添加了这个宏，equalTo就等价于mas_equalTo
#define MAS_SHORTHAND_GLOBALS
// 这个头文件一定要放在上面两个宏的后面

//-------------------自动布局宏定义-------------------------
#define MAS_PADDING   10

//weak & strong self
#define MIS_WS                  __weak __typeof(&*self)weakSelf     = self;
#define MIS_SS(WKSELF)          __strong __typeof(&*self)strongSelf = WKSELF;
#define MIS_ONE_PX              (1.0f / [UIScreen mainScreen].scale)

#define MIS_SAFE_OBJ(__OBJ) ((__OBJ) == nil ? @"": (__OBJ))
#define MIS_SAFE_INT_OBJ(__OBJ) ((__OBJ) > 0  ? (__OBJ) :  0)
#define MIS_SAFE_ARRAYOBJ(__OBJ) ((__OBJ) == nil ? @[]: (__OBJ))


//默认是时间格式串
#define MIS_DATE_FORMAT_KEY  @"yyyy-MM-dd HH:mm:ss"
#define MIS_YYMMDD_FORMAT_KEY  @"yyyyMMdd"
#define MIS_HHMM_FORMAT_KEY  @"HH:mm"



//-------------------获取设备大小-------------------------
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define IPhone6 [UIScreen mainScreen].bounds.size.width > 320 ? YES : NO

#define IPhone5 [UIScreen mainScreen].bounds.size.height <= 568 ? YES : NO

#define iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//NavBar高度
#define NavigationBar_HEIGHT 44.0f
//TabBar高度
#define TabBar_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
//StatusBar高度
#define StatusBar_HEIGHT (iPhoneX ? 44.0f : 20.0f)
//ToolsBar高度
#define ToolsBar_HEIGHT 44.0f

#define IPHONEX_MARGIN_BOTTOM (iPhoneX ? 34.0f : 0.0f)

#define IPHONE_LANDSCAPE_MARGIN_BOTTOM (iPhoneX ? 21.0f : 0.0f)

//ipad 左右边距
#define IPAD_LF_RT_PADDING  (SCREEN_WIDTH * 0.3)


//1个像素大小
#define MIS_ONE_PX (1.0f / [UIScreen mainScreen].scale)

//keyWindow
#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define VIEW_HEIGHT (SCREEN_HEIGHT - StatusBar_HEIGHT - NavigationBar_HEIGHT)
#define VIEW_WIDTH SCREEN_WIDTH

//设置View的tag属性
#define VIEWWITHTAG(_OBJECT, _TAG) [_OBJECT viewWithTag : _TAG]

//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian * 180.0)/(M_PI)

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//背景色
#define VIEW_BGCOLOR RGB(247.0f, 247.0f, 247.0f)

//控件灰色边框
#define VIEW_BORDER_GRAY_COLOR   RGB(0.85, 0.85, 0.85)

//分割线颜色
#define Cutting_line_COLOR   RGB(240, 240, 240)

//论坛高亮蓝色
#define FORUM_BLUE_COLOR RGB(40.0f, 77.0f, 134.0f)

//半透明背景
#define VIEW_ALPHA_BGCOLOR  [UIColor colorWithWhite:0.5 alpha:0.5]

//蓝色按钮背景
#define BUTTON_NORMAL_COLOR RGB(39, 88, 228)

//橙色背景图片
#define BUTTON_ORANGE_IMAGE IMAGE_WITH_RGB(0xfe8c1d)

//橙色按钮高亮
#define BUTTON_ORANGE_HIGHLIGHTED_IMAGE IMAGE_WITH_RGB(0xd6710f)

//蓝色背景图片
#define BUTTON_NORMAL_IMAGE IMAGE_WITH_RGB(0x2758e4)

//蓝色按钮高亮
#define BUTTON_HIGHLIGHTED_IMAGE IMAGE_WITH_RGB(0x173fb1)

//蓝色按钮高度
#define BUTTON_NORMAL_HEIGHT  40

//蓝色按钮圆角
#define BUTTON_CORNER_RADIUS 20

#define  PURPLE_COLOR  [UIColor colorWithRed:0.66 green:0.37 blue:0.60 alpha:1.00]


#define COLOR_FOR_BG_BORDER UIColorFromRGB(0xECECEC)


//默认边距
#define PADDING_H 10.f

#define PADDING_V 5.f

//教师版  常用颜色

#define  GREEN_COLOR   [UIColor colorWithRed:0.20 green:0.65 blue:0.30 alpha:1.00]

#define  RED_COLOR   [UIColor colorWithRed:0.91 green:0.36 blue:0.36 alpha:1.00]

#define  YELLOW_COLOR [UIColor colorWithRed:0.90 green:0.53 blue:0.20 alpha:1.00]

#define  PURPLE_COLOR  [UIColor colorWithRed:0.66 green:0.37 blue:0.60 alpha:1.00]

#define  BAND_MEMBER_SELECTED_BG_COLOR  UIColorFromRGB(0x2758e4)
//背景色
#define CLEAR_COLOR [UIColor clearColor] //clear color
#define BLACK_COLOR [UIColor blackColor] //black color
#define WHITE_COLOR [UIColor whiteColor] //white color
#define GRAY_COLOR  [UIColor grayColor]  //grayColor color
#define ORANGE_COLOR [UIColor orangeColor] //orange color
#define LIGHT_GRAY_COLOR  [UIColor lightGrayColor] //lightGrayColor color
#define BUTTON_BLUE_COLOR  [UIColor colorWithRed:0.09 green:0.53 blue:1 alpha:1]

//字体
#define NFont(__SIZE) [UIFont systemFontOfSize:__SIZE] //system font with size
#define IFont(__SIZE) [UIFont italicSystemFontOfSize:__SIZE] //system font with size
#define BFont(__SIZE) [UIFont boldSystemFontOfSize:__SIZE]//system bold font with size
#define Font(__NAME, __SIZE) [UIFont fontWithName:__NAME size:__SIZE] //font with name and size

//注册/移除 通知中心
#define POST_NOTIFY(__NAME, __OBJ, __INFO) [[NSNotificationCenter defaultCenter] postNotificationName:__NAME object:__OBJ userInfo:__INFO];
#define LISTEN_NOTIFY(__NAME, __OBSERVER, __SELECTER)    [[NSNotificationCenter defaultCenter] addObserver:__OBSERVER selector:__SELECTER name:__NAME object:nil];//listen notification
#define REMOVE_NOTIFY(__OBSERVER)     [[NSNotificationCenter defaultCenter] removeObserver:__OBSERVER]; //remove listen Observer

//读取本地图片
#define IMAGE_WITH_FILE(_NAME,_EXT) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:_NAME ofType:_EXT]]
#define IMAGE_WITH_NAME(_NAME) [UIImage imageNamed:_NAME]
#define IMAGE_WITH_RGB(__RGB) [UIImage imageWithColor:UIColorFromRGB(__RGB)]

#define STRETCHABLE_IMG_WITH(__NAME, __LEFTCAP, __TOPCAP)[IMAGE_WITH_NAME(__NAME) stretchableImageWithLeftCapWidth:__LEFTCAP topCapHeight:__TOPCAP]
#define STRETCHABLE_IMG(__NAME)[IMAGE_WITH_NAME(__NAME) stretchableImageWithLeftCapWidth:nearbyintf(IMAGE_WITH_NAME(__NAME).size.width / 2.0) topCapHeight:nearbyintf(IMAGE_WITH_NAME(__NAME).size.height / 2.0)]

//FMDB读表
#define STRVALUE(__SET, __NAME)       [(__SET) stringForColumn:(__NAME)]
#define DATETIMEVALUE(__SET, __NAME)  [(__SET) dateForColumn:(__NAME)]
#define INT8VALUE(__SET, __NAME)      [(__SET) intForColumn:(__NAME)]
#define INT16VALUE(__SET, __NAME)     [(__SET) intForColumn:(__NAME)]
#define INT32VALUE(__SET, __NAME)     [(__SET) intForColumn:(__NAME)]
#define INT64VALUE(__SET, __NAME)     [(__SET) longLongIntForColumn:(__NAME)]
#define DOUBLEVALUE(__SET, __NAME)    [(__SET) doubleForColumn:(__NAME)]

#if OPEN_LOG
#define MISLog(...)             NSLog(__VA_ARGS__);
#define MISLogFunc              MISLog(@"%s", __FUNCTION__);
#define MISLogLine              MISLog(@"Line:%d", __LINE__);
#define MISLogFile              MISLog(@"%s", __FILE__);
#define MISLogError(__ERROR)    MISLog(@"%s, Error:%@", __FUNCTION__, __ERROR);
#define NSSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else
#define MISLog(...)             {}
#define MISLogFunc              {}
#define MISLogLine              {}
#define MISLogFile              {}
#define MISLogError(__ERROR)    {}
#define NSSLog(FORMAT, ...)     {}
#endif

//calc run time

#define MIS_CALC_TIME_BEGIN                                            \
printf("******Calc In Fun:%s******\n", __FUNCTION__);              \
printf("================Line:[%d]==================\n", __LINE__); \
double begin = CFAbsoluteTimeGetCurrent();

#define MIS_CALC_TIME_END                                              \
printf("Run Duration:[%f]\n", CFAbsoluteTimeGetCurrent() - begin); \
printf("================Line:[%d]==================\n", __LINE__);


//特殊设置
#define Segment_Title_Height  50

#define WRITE_BAND_TITLE_KEY @"title"
#define WRITE_BAND_HASBUTTON_KEY @"hasButton"

#endif /* Header_h */
