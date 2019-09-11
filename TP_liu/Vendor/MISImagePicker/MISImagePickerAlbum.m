
/***********************************************************
 //  MISImagePickerAlbum.m
 //  Mao Kebing
 //  Created by Edu on 13-7-25.
 //  Copyright (c) 2013 Eduapp. All rights reserved.
 ***********************************************************/

#import "MISImagePickerAlbum.h"

@implementation MISImagePickerAlbum


- (NSString *)description {
	return [NSString stringWithFormat:@"<%@, %p, title:%@, assets:%@, posterImage:%@>",
			[self class],
			self,
			self.title,
			self.assets,
			self.posterImage];
}

@end
