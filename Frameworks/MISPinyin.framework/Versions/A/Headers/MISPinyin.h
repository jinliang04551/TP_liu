//
//  MISPinyin.h
//  0000
//
//  Created by Mao on 12/16/15.
//  Copyright © 2015 00000. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MISPinyin : NSObject

/**
 *  获取汉字拼音
 *
 *  @param hanzi 输入汉字
 *
 *  @return 拼音
 */
+ (NSString *)pinyinWithHanzi:(NSString *)hanzi;


@end
