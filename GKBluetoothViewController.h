//
//  GKBluetoothViewController.h
//  GKBluetooth
//
//  Created by 俊彦 木村 on 11/09/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface GKBluetoothViewController : UIViewController <GKPeerPickerControllerDelegate, GKSessionDelegate>{

    GKSession *currentSession;
    NSString *curentPeerID;
    
    IBOutlet UITextView *txtField;
    IBOutlet UITextField *msgField;
    IBOutlet UITextField *statusField;
    IBOutlet UIButton *connectBtn;
    IBOutlet UIButton *sendBtn;
}

@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, retain) NSString *currentPeerID;
@property (nonatomic, retain) IBOutlet UITextView *txtField;
@property (nonatomic, retain) IBOutlet UITextField *msgField;
@property (nonatomic, retain) IBOutlet UITextField *statusField;
@property (nonatomic, retain) IBOutlet UIButton *connectBtn;
@property (nonatomic, retain) IBOutlet UIButton *sendBtn;

- (IBAction)btnConnect:(id)sender;
- (IBAction)btnSend:(id)sender;

@end
