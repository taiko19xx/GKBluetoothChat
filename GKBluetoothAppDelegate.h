//
//  GKBluetoothAppDelegate.h
//  GKBluetooth
//
//  Created by 俊彦 木村 on 11/09/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GKBluetoothViewController;

@interface GKBluetoothAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GKBluetoothViewController *viewController;

@end
