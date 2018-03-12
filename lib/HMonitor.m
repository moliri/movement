//
//  HMonitor.m
//  NetworkingAssignment
//
//  Created by Harihar Subramanyam on 3/20/14.
//  Copyright (c) 2014 Harihar Subramanyam. All rights reserved.
//

#import "HMonitor.h"
#import "HDownloader.h"
#import "HDownloadTestDelegate.h"

// Download the file from this URL
#define URL @"https://github.com/fivethirtyeight/data/archive/master.zip"

@interface HMonitor()

@property (nonatomic, strong) HDownloader *downloadTest;

@end


@implementation HMonitor

/*
 Get the download test
 */
- (HDownloader *)downloadTest{
    if (!_downloadTest) {
        _downloadTest = [[HDownloader alloc] initWithDelegate:self];
    }
    return _downloadTest;
}

/*
 Run the download test
 */
- (void)run_test {
    
    
    // Extract the download interval and test time from the text field
    double interval = 10.0;
    double testTime = 20.0;
    // If either value is zero, return
    if(ABS(interval*testTime) < 0.01){
        return;
    }
    
    // Try to run the test
    BOOL testRunning = [self.downloadTest doDownloadTestForURLString:URL withTestTime:testTime andInterval:interval];
    
    // If the test is running
    if (testRunning) {
        NSLog(@"Test Started");
    }
}

/*
 (Method from HDownloadTestDelegate protocol)
 When the test has finished, save the results
 */
- (void)onTestComplete:(HTestResults *)testResults{
    NSLog(@"Test Complete with filesize %d", testResults.fileSize);
    
    // Print all the output to the label
    for (int i = 0; i < [testResults.latencies count]; i++) {
        double throughput = [((NSNumber *)[testResults.throughputs objectAtIndex:i]) doubleValue];
        double latency = [((NSNumber *)[testResults.latencies objectAtIndex:i]) doubleValue];
    }
}

@end
