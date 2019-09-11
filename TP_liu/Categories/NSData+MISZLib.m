//
//  NSData+MISZLib.m
//  EPlus
//
//  Created by Mao on 26/08/2017.
//  Copyright © 2017 Eduapp. All rights reserved.
//

#import "NSData+MISZLib.h"
#import <zlib.h>

static const UInt32 MISZLibChunk    = 1024 * 4 * 4;

@implementation NSData(MISZLib)

/**
 * zlib 解压缩
 */
- (NSData *)mis_dataWithZLibInflate {
	int ret, flush;
	unsigned have;
	z_stream strm;
	unsigned char in[MISZLibChunk];
	unsigned char out[MISZLibChunk];
	
	/* allocate deflate state */
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	ret = deflateInit(&strm, Z_BEST_COMPRESSION);
	if (ret != Z_OK)
		return nil;
	
	NSInteger pos = 0;
	NSInteger left = self.length;
	
	//output
	NSMutableData* outData = [NSMutableData data];
	
	/* compress until end of file */
	do {
		NSInteger len = left > MISZLibChunk ? MISZLibChunk : left;
		[self getBytes:in range:NSMakeRange(pos, len)];
		pos += len;
		left -= len;
		
		strm.avail_in = (uInt)len;
		flush = left == 0 ? Z_FINISH : Z_NO_FLUSH;
		strm.next_in = in;
		
		/* run deflate() on input until output buffer not full, finish
		 compression if all of source has been read in */
		do {
			strm.avail_out = MISZLibChunk;
			strm.next_out = out;
			ret = deflate(&strm, flush);    /* no bad return value */
			assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
			have = MISZLibChunk - strm.avail_out;
			
			[outData appendBytes:out length:have];
		} while (strm.avail_out == 0);
		assert(strm.avail_in == 0);     /* all input will be used */
		
		/* done when last data in file processed */
	} while (flush != Z_FINISH);
	assert(ret == Z_STREAM_END);        /* stream will be complete */
	
	/* clean up and return */
	(void)deflateEnd(&strm);
	
	return [outData copy];
}

/**
 * zlib 压缩
 */
- (NSData *)mis_dataWithZLibDeflate {
	int ret, flush;
	unsigned have;
	z_stream strm;
	unsigned char in[MISZLibChunk];
	unsigned char out[MISZLibChunk];
	
	/* allocate deflate state */
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	ret = deflateInit(&strm, Z_BEST_COMPRESSION);
	if (ret != Z_OK)
		return nil;
	
	NSInteger pos = 0;
	NSInteger left = self.length;
	
	//output
	NSMutableData* outData = [NSMutableData data];
	
	/* compress until end of file */
	do {
		NSInteger len = left > MISZLibChunk ? MISZLibChunk : left;
		[self getBytes:in range:NSMakeRange(pos, len)];
		pos += len;
		left -= len;
		
		strm.avail_in = (uInt)len;
		flush = left == 0 ? Z_FINISH : Z_NO_FLUSH;
		strm.next_in = in;
		
		/* run deflate() on input until output buffer not full, finish
		 compression if all of source has been read in */
		do {
			strm.avail_out = MISZLibChunk;
			strm.next_out = out;
			ret = deflate(&strm, flush);    /* no bad return value */
			assert(ret != Z_STREAM_ERROR);  /* state not clobbered */
			have = MISZLibChunk - strm.avail_out;
			
			[outData appendBytes:out length:have];
		} while (strm.avail_out == 0);
		assert(strm.avail_in == 0);     /* all input will be used */
		
		/* done when last data in file processed */
	} while (flush != Z_FINISH);
	assert(ret == Z_STREAM_END);        /* stream will be complete */
	
	/* clean up and return */
	(void)deflateEnd(&strm);
	
	return [outData copy];
}

@end
