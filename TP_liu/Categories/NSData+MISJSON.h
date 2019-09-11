//
//  NSData+MISJSON.h
//  edua
//
//  Created by Mao on 11/9/15.
//  Copyright (c) 2015 aspire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(MISJSON)


/**
 *  返回解析后的JSON对象
 *
 *  @return obj
 */
- (id)mis_JSONObject;

/**
 *  返回解析后的JSON对象(可变容器)
 *
 *  @return obj
 */
- (id)mis_mutableJSONObject;

@end
