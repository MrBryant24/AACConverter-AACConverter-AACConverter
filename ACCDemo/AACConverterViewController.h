//
//  tempViewController.h
//  BaseProjects
//
//  Created by name on 14年4月13日.
//  Copyright (c) 2014年 com.kapple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPAACAudioConverter.h"
@interface AACConverterViewController : UIViewController<TPAACAudioConverterDelegate>
{

    TPAACAudioConverter *audioConverter;
}
@end
