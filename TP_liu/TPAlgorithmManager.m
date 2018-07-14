
//
//  TPAlgorithmManager.m
//  TP_liu
//
//  Created by liu on 2018/6/4.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "TPAlgorithmManager.h"
#import "algorithm.h"
#import "TPConfig.h"

#define BEGIN_HEART_BEAT_WARNING_RATIO 0.65
#define STOP_HEART_BEAT_WARNING_RATIO  0.60
static const int MAX_HEARTBEAT_RATE = 220; //最大心率


@interface TPAlgorithmManager()
/**
 心率警告开始时间
 */
@property (nonatomic, strong) NSDate *heart_beat_warning_start_time;

/**
 心率警告结束时间
 */
@property (nonatomic, strong) NSDate *heart_beat_warning_end_time;

/**
 最大心率为 (220 - age)
 */
@property (nonatomic, assign) int max_limit_heartbeat;

/**
 所有警告区间内的心率
 */
@property (nonatomic, assign) int all_heart_beat_alert;

/**
 所有警告区间内的平均心率占比
 */
@property (nonatomic, assign) float avg_heart_beat_alert_ratio;


/**
 心率警告持续时间
 */
@property (nonatomic, assign) NSTimeInterval alert_duration;

/**
 心率告警区间内的心率个数
 */
@property (nonatomic, assign) NSInteger heart_beat_count_during_alert;


@property (nonatomic, assign) int student_age;

/**
 实时心率
 */
@property (nonatomic, assign) int currentHeartbeat;


@property (nonatomic, assign) int heartbeat_warning_times;

@end



@implementation TPAlgorithmManager
+ (instancetype)manager {
    static TPAlgorithmManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)testAlgorithm {
//    [self testBubbleSort];
//    [self testQuickSort];
    [self processHeartbeatWarining];
}


- (void)processHeartbeatWarining {
    self.student_age = 16;
    
    self.max_limit_heartbeat = MAX_HEARTBEAT_RATE - self.student_age;
    float heart_beat_ratio = _currentHeartbeat / self.max_limit_heartbeat * 1.0;
    
    NSSLog(@"self.student_age:%@",@(self.student_age));
    NSSLog(@"self.max_limit_heartbeat:%@",@(self.max_limit_heartbeat));
    NSSLog(@"heart_beat_ratio:%0.2f",heart_beat_ratio);
    
    
    if (heart_beat_ratio >= STOP_HEART_BEAT_WARNING_RATIO) {
        if (heart_beat_ratio > BEGIN_HEART_BEAT_WARNING_RATIO) {
            self.heart_beat_warning_start_time = [NSDate date];
            self.heart_beat_count_during_alert = 0;
            NSSLog(@"================heart_beat_ratio >= BEGIN_HEART_BEAT_WARNING_RATIO=====================");
        }
        NSSLog(@"================heart_beat_ratio >= STOP_HEART_BEAT_WARNING_RATIO=====================");
        
        self.all_heart_beat_alert += self.currentHeartbeat;
        self.heart_beat_count_during_alert++;
        
    }else {
        
        NSSLog(@"================below80%%=====================");
        
        self.heart_beat_warning_end_time = [NSDate date];
        self.alert_duration = ABS([self.heart_beat_warning_end_time timeIntervalSinceDate:self.heart_beat_warning_start_time]);
        //告警区间内平均心率
        int avg_heart_beat_alert = (UInt8)(self.all_heart_beat_alert /self.heart_beat_count_during_alert);
        self.avg_heart_beat_alert_ratio = floorf(avg_heart_beat_alert/self.max_limit_heartbeat);
        NSSLog(@"%s self.avg_heart_beat_alert_ratio:%@",__func__,@(self.avg_heart_beat_alert_ratio));
    }
    
    self.heartbeat_warning_times += [self isPopWarning] ? 1 : 0;
    
    
    
    NSSLog(@"alert_duration:%@",@(self.alert_duration));
    NSSLog(@"all_heart_beat_alert:%@",@(self.all_heart_beat_alert));
    NSSLog(@"heartbeat_warning_times:%@",@(self.heartbeat_warning_times));
    
}


/**
 是否抛出警告
 
 @return BOOL
 */
- (BOOL)isPopWarning {
    //心率告警变量x
    float warningPara = (self.avg_heart_beat_alert_ratio - 0.95) * 100/ 2.5;
    NSSLog(@"warningPara:%@",@(warningPara));
    float sigmoidX = [self sigmoidFunc:warningPara];
    float value = self.alert_duration * sigmoidX;
    return value > 10 ? YES : NO;
}


- (float)sigmoidFunc:(int)x {
    float sigmoidValue = 1/(1 + expf(-x));
    NSSLog(@"%s sigmoidValue:%@",__func__,@(sigmoidValue));
    return  sigmoidValue;
}


- (void)testBubbleSort {
    NSLog(@"%s",__func__);

    int a[] = {23,33,90,29,11,5,45,67};
    int ArrLength = sizeof(a) / sizeof(int);
    bubbleSort(a, ArrLength);
    for (int i = 0; i < ArrLength; ++i) {
        printf("i:%d value:%d\n",i,a[i]);
    }
    
}


- (void)testQuickSort {
    NSLog(@"%s",__func__);
    int a[] = {23,33,90,29,11,5,45,67};
    int len = sizeof(a) / sizeof(int);
    quick_sort(a, 0, len - 1);
    for (int i = 0; i < len; ++i) {
        printf("i:%d value:%d\n",i,a[i]);
    }
    
   int pos = binarySearch(a, len, 29);
    printf("pos:%d \n",pos);

}

@end

#undef BEGIN_HEART_BEAT_WARNING_RATIO
#undef STOP_HEART_BEAT_WARNING_RATIO
