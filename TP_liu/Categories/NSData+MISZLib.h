//
//  NSData+MISZLib.h
//  EPlus
//
//  Created by Mao on 26/08/2017.
//  Copyright © 2017 Eduapp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(MISZLib)

/**
 * zlib 压缩
 */
- (NSData *)mis_dataWithZLibDeflate;

/**
 * zlib 解压缩
 */
- (NSData *)mis_dataWithZLibInflate;


@end
