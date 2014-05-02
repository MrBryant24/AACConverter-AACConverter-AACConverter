//
//  tempViewController.m
//  BaseProjects
//
//  Created by name on 14年4月13日.
//  Copyright (c) 2014年 com.kapple. All rights reserved.
//

#import "AACConverterViewController.h"
#import <AVFoundation/AVFoundation.h>

#define checkResult(result,operation) (_checkResult((result),(operation),__FILE__,__LINE__))

static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) {
    if ( result != noErr ) {
        NSLog(@"%s:%d: %s result %d %08X %4.4s\n", file, line, operation, (int)result, (int)result, (char*)&result);
        return NO;
    }
    return YES;
}

@interface AACConverterViewController ()

@end

@implementation AACConverterViewController


// Callback to be notified of audio session interruptions (which have an impact on the conversion process)
static void interruptionListener(void *inClientData, UInt32 inInterruption)
{
	AACConverterViewController *THIS = (__bridge AACConverterViewController *)inClientData;
	
	if (inInterruption == kAudioSessionEndInterruption) {
		// make sure we are again the active session
		checkResult(AudioSessionSetActive(true), "resume audio session");
        if ( THIS->audioConverter ) [THIS->audioConverter resume];
	}
	
	if (inInterruption == kAudioSessionBeginInterruption) {
        if ( THIS->audioConverter ) [THIS->audioConverter interrupt];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self convert];
    
    
}
-(void)convert{
    if ( ![TPAACAudioConverter AACConverterAvailable] ) {
        
        return;
    }
    
    // Initialise audio session, and register an interruption listener, important for AAC conversion
 //   checkResult(AudioSessionInitialize(NULL, NULL, interruptionListener, (__bridge void *)(self), "会议监听");
    
    checkResult(AudioSessionInitialize(NULL, NULL, interruptionListener, NULL), "initialise audio session");
    
    // Set up an audio session compatible with AAC conversion.  Note that AAC conversion is incompatible with any session that provides mixing with other device audio.
  
       UInt32 audioCategory = kAudioSessionCategory_MediaPlayback;
                
   checkResult(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory), "setup session category");
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self
                                                             source:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp3"]
                                                        destination:[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:@"audso.m4r"]];
    [audioConverter start];
}
#pragma mark - Audio converter delegate
/**
 *  监听转换进度
 *
 *  @param converter TPAACAudioConverter
 *  @param progress  进度数值
 */
-(void)AACAudioConverter:(TPAACAudioConverter *)converter didMakeProgress:(CGFloat)progress {
    
    
    //    self.progressView.progress = progress;
}
/**
 *  转换结束
 *
 *  @param converter TPAACAudioConverter
 */
-(void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter {
    
    audioConverter = nil;
}

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error {
   
    audioConverter = nil;
}

@end
