//
//  TPTestDrawView.m
//  TP_liu
//
//  Created by liu on 2018/7/12.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TPTestDrawView.h"
#import "TPConfig.h"


#define IS_DASH @"isDash"
#define POINTS @"points"


@interface TPTestDrawView()

@property (nonatomic, strong) UIBezierPath* curvePath;
/**
 绘制点的绘制类型数组
 */
@property (nonatomic, strong) NSMutableArray<NSNumber *> *heartbeatIsDashArray;

@end


@implementation TPTestDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    UIBezierPath *allPath = [UIBezierPath bezierPath];
//
//    UIBezierPath *path1 = [UIBezierPath bezierPath];
//    [path1 moveToPoint:CGPointMake(100.0, 100.0)];
//    [path1 addLineToPoint:CGPointMake(150.0, 100.0f)];
//    [[UIColor redColor] setStroke];
//    path1.lineWidth = 4.0f;
//    path1.lineCapStyle = kCGLineCapRound;
//    path1.lineJoinStyle = kCGLineJoinRound;
//    [path1 stroke];
//
//    UIBezierPath *path2 = [UIBezierPath bezierPath];
//    [path2 moveToPoint:CGPointMake(150.0, 100.0)];
//    [path2 addLineToPoint:CGPointMake(200.0f, 100.0f)];
//    CGFloat dash[] = {10.0, 5.0};
//    [path2 setLineDash: dash count: 2 phase: 0];
//
//    [[UIColor grayColor] setStroke];
//    path2.lineWidth = 4.0f;
//    path2.lineCapStyle = kCGLineCapRound;
//    path2.lineJoinStyle = kCGLineJoinRound;
//    [path2 stroke];
//
//    [allPath appendPath:path1];
//    [allPath appendPath:path2];


    NSMutableArray *points = [NSMutableArray array];
    NSMutableArray *heartbeatIsDashArray = [NSMutableArray array];

    points = [@[@(CGPointMake(100.0, 100.0)),@(CGPointMake(101.0, 101.0)),@(CGPointMake(102, 102)),@(CGPointMake(103, 103)),@(CGPointMake(108, 108)),@(CGPointMake(130, 130)),@(CGPointMake(150.0, 150.0)),@(CGPointMake(150.0, 150.0)),@(CGPointMake(150.0, 150.0)),@(CGPointMake(120.0, 120.0))] mutableCopy];
    
    heartbeatIsDashArray = [@[@(0),@(0),@(0),@(1),@(1),@(0),@(1),@(0),@(0),@(0)] mutableCopy];
    
    
//    for (NSInteger i = 0; i < 40; ++i) {
//        CGPoint point = CGPointMake(100.0f + i, 100.0f + i * 2);
//        [points addObject:@(point)];
//        if (i < 10) {
//            [heartbeatIsDashArray addObject:@(0)];
//        }else if(i >= 10 && i < 30) {
//            [heartbeatIsDashArray addObject:@(1)];
//        }else {
//            [heartbeatIsDashArray addObject:@(0)];
//        }
//    }
    
    NSSLog(@"points:%@",points);
    NSSLog(@"heartbeatIsDashArray:%@",heartbeatIsDashArray);

    
    [self processDashLineWithPoints:points heartbeatIsDashArray:heartbeatIsDashArray yPoint:90.0f];
}



- (void)processDashLineWithPoints:(NSMutableArray *)points
             heartbeatIsDashArray:(NSMutableArray *)heartbeatIsDashArray
                           yPoint:(CGFloat)yStart {
    
    //拆分实线点区段和虚线点区段
    NSMutableArray *dashRangeArray = [self processPoints:points heartbeatIsDashArray:heartbeatIsDashArray];
    
    NSSLog(@"dashRangeArray:%@",dashRangeArray);
    
    UIBezierPath* allPath = [UIBezierPath bezierPath];

    NSMutableArray *splitArray = [self splitCompentPoints:points withDashRangeArray:dashRangeArray];
    NSSLog(@"splitArray:%@",splitArray);

    for (NSInteger i = 0; i < splitArray.count; ++i) {
        NSDictionary *dic  = splitArray[i];
        BOOL isDash = [dic[IS_DASH] boolValue];
        NSArray *points = dic[POINTS];
        
        if (isDash) {
            UIBezierPath* dashPath = [self dashPathWithDashPoints:points];
            [[UIColor grayColor] setStroke];
            dashPath.lineWidth = MIS_ONE_PX * 4.0f;
            dashPath.lineCapStyle = kCGLineCapRound;
            dashPath.lineJoinStyle = kCGLineJoinRound;
            [dashPath stroke];
            [allPath appendPath:dashPath];
            NSSLog(@"++++++++++isDash+++++++++");
        }else {
            UIBezierPath* normalPath = [self quadCurvedPathWithPoints:points];
            [[UIColor redColor] setStroke];
            normalPath.lineWidth = MIS_ONE_PX * 4.0f;
            normalPath.lineCapStyle = kCGLineCapRound;
            normalPath.lineJoinStyle = kCGLineJoinRound;
            [normalPath stroke];
            [allPath appendPath:normalPath];
            NSSLog(@"++++++++++notDash+++++++++");
        }
    
    }
    
    //画线
    self.curvePath = [allPath copy];

    CGPoint lastPoint = [points.lastObject CGPointValue];
    CGPoint fristPoint = [points.firstObject CGPointValue];


    [self.curvePath addLineToPoint:CGPointMake(lastPoint.x, yStart)];
    [self.curvePath addLineToPoint:CGPointMake(fristPoint.x, yStart)];
    [self.curvePath addLineToPoint:fristPoint];
    [self.curvePath closePath];

}

- (NSMutableArray *)splitCompentPoints:(NSMutableArray *)points withDashRangeArray:(NSArray *)dashRangeArray {
    if (points.count == 0 || dashRangeArray.count == 0) {
        return [@[] mutableCopy];
    }
    
    
    NSMutableArray *operationdashRangeArray = [dashRangeArray mutableCopy];

    NSUInteger dashRangeIndex = 0;
    NSMutableArray *dicArray = [NSMutableArray array];

    NSMutableArray *dashPoints = [NSMutableArray array];
    NSMutableArray *densnityPoints = [NSMutableArray array];
    
    NSRange dashRange = [operationdashRangeArray[dashRangeIndex] rangeValue];
    for (NSInteger i = 0; i < points.count; ++i) {
    
        if (dashRange.length > 0) {
            //还有dash区段
            if (i < dashRange.location) {
                [densnityPoints addObject:points[i]];
            }else if (i == dashRange.location){
                [dicArray addObject:@{IS_DASH:@(0),POINTS:densnityPoints}];
                densnityPoints = [NSMutableArray array];
                [dashPoints addObject:points[i]];
            }else if (i > dashRange.location && i < (dashRange.location + dashRange.length - 1)){
                [dashPoints addObject:points[i]];
            }else if (i == (dashRange.location + dashRange.length - 1 )){
                [dashPoints addObject:points[i]];
                [dicArray addObject:@{IS_DASH:@(1),POINTS:dashPoints}];
                dashPoints = [NSMutableArray array];
                
                if (i < points.count - 1) {
                    dashRangeIndex++;
                    if (dashRangeIndex <= operationdashRangeArray.count - 1) {
                        dashRange = [operationdashRangeArray[dashRangeIndex] rangeValue];
                    }else {
                        dashRange = NSMakeRange(0, 0);
                    }
                }
            }
        }else {
            //没有dash区段
            [densnityPoints addObject:points[i]];
            if (i == points.count - 1) {
                [dicArray addObject:@{IS_DASH:@(0),POINTS:densnityPoints}];
            }
        }
        
    }

    return [dicArray mutableCopy];

}


- (NSMutableArray *)processPoints:(NSMutableArray *)points
             heartbeatIsDashArray:(NSMutableArray *)heartbeatIsDashArray {
    
    if (points.count == 0 || heartbeatIsDashArray.count == 0) {
        return [@[] mutableCopy];
    }
    
    
    NSMutableArray *dashRangeArray = [NSMutableArray array];
    
    NSUInteger dashLoc = 0;
    NSUInteger dashLength = 0;
    
    for (NSInteger i = 0; i < heartbeatIsDashArray.count; ++i) {
        BOOL isDash = [heartbeatIsDashArray[i] boolValue];
        if (isDash) {
            if (dashLoc == 0 && dashLength == 0) {
                dashLoc = i;
                dashLength++;
            }else {
                if (i == heartbeatIsDashArray.count - 1) {
                    //最后一个点
                    NSRange dashRange = NSMakeRange(dashLoc, dashLength);
                    [dashRangeArray addObject:[NSValue valueWithRange:dashRange]];
                }
                dashLength++;
            }
        }else {
            if (i == 0) {
                continue;
            }else {

                BOOL lastIsDash = [heartbeatIsDashArray[i - 1] boolValue];
                if (lastIsDash) {
                    //虚线点后的第一个非虚线点重置状态并且保存虚线点range
                    NSRange dashRange = NSMakeRange(dashLoc, dashLength);
                    if (dashLength > 0) {
                        [dashRangeArray addObject:[NSValue valueWithRange:dashRange]];
                    }
                    dashLoc = 0;
                    dashLength = 0;
                }
            }
        }
      
    }
    
    return [dashRangeArray mutableCopy];
}

//- (NSMutableArray *)processPoints:(NSMutableArray *)points
//             heartbeatIsDashArray:(NSMutableArray *)heartbeatIsDashArray {
//
//    if (points.count == 0 || heartbeatIsDashArray.count == 0) {
//        return [@[] mutableCopy];
//    }
//
//
//    NSMutableArray *allPoints = [NSMutableArray array];
//
//    NSMutableArray *dashPoints = [NSMutableArray array];
//    NSMutableArray *densnityPoints = [NSMutableArray array];
//
//
//    BOOL isDashPoint = [heartbeatIsDashArray.firstObject boolValue];
//    NSInteger i = 1;
//
//    while (i < points.count) {
//        NSValue *value = points[i];
//
//        BOOL isDashCurrentPoint = [heartbeatIsDashArray[i] boolValue];
//
//        if (isDashPoint == isDashCurrentPoint) {
//            if (isDashPoint) {
//                [dashPoints addObject:value];
//            }else {
//                [densnityPoints addObject:value];
//            }
//
//            i++;
//        }else {
//            if (isDashPoint) {
//                [allPoints addObject:@{IS_DASH:@(1),POINTS:dashPoints}];
//            }else {
//                [allPoints addObject:@{IS_DASH:@(0),POINTS:densnityPoints}];
//            }
//
//            dashPoints = [NSMutableArray array];
//            densnityPoints = [NSMutableArray array];
//            isDashPoint = isDashCurrentPoint;
//        }
//
//    }
//
//    return [allPoints mutableCopy];
//}

/*圆滑线补点*/
- (UIBezierPath *)quadCurvedPathWithPoints:(NSArray *)points {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];
    
    if (points.count == 2) {
        value = points[1];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
        return path;
    }
    
    for (NSUInteger i = 1; i < points.count; i++) {
        value = points[i];
        CGPoint p2 = [value CGPointValue];
        
        CGPoint midPoint = midPointForPoints(p1, p2);
        [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
        [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];
        
        p1 = p2;
    }
    return path;
}

- (UIBezierPath *)dashPathWithDashPoints:(NSArray *)dashPoints {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [self drawDashLineWithPath:path];
    
    CGPoint p1 = [dashPoints.firstObject CGPointValue];
    [path moveToPoint:p1];
    CGPoint lastPoint = [dashPoints.lastObject CGPointValue];
    [path  addLineToPoint:lastPoint];
    
    [path stroke];
    return path;
}


//绘制虚线
- (void)drawDashLineWithPath:(UIBezierPath *)bezierPath {
    CGFloat dash[] = {MIS_ONE_PX * 10.0, MIS_ONE_PX *6.0};
    [bezierPath setLineDash: dash count: 2 phase: 0];
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    CGFloat diffY = ABS(p2.y - controlPoint.y);
    
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    
    return controlPoint;
}

@end

#undef IS_DASH
#undef POINTS

