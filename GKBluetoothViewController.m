//
//  GKBluetoothViewController.m
//  GKBluetooth
//
//  Created by 俊彦 木村 on 11/09/28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "GKBluetoothViewController.h"

@implementation GKBluetoothViewController
@synthesize currentSession, currentPeerID;
@synthesize txtField, msgField, statusField;
@synthesize connectBtn, sendBtn;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [txtField release];
    txtField = nil;
    [msgField release];
    msgField = nil;
    [statusField release];
    statusField = nil;
    [connectBtn release];
    connectBtn = nil;
    [sendBtn release];
    sendBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GKPeerPickerControllerDelegate

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    self.currentPeerID = peerID;
    self.currentSession = session;
    
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
    
}

- (void)peerPickerControllerDidCancel: (GKPeerPickerController *)picker {
    picker.delegate = nil;
    [picker autorelease];
}

#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state) {
        case GKPeerStateConnected:
            self.statusField.text = @"Connected";
            self.connectBtn.titleLabel.text = @"Disconnect";
            self.connectBtn.tag = 1;
            self.msgField.enabled = true;
            self.sendBtn.enabled = true;
            break;
            
        case GKPeerStateDisconnected:
            self.statusField.text = @"Disconnected";
            self.connectBtn.titleLabel.text = @"Connect";
            self.currentSession.available = NO;
            [self.currentSession setDataReceiveHandler:nil withContext:nil];
            self.connectBtn.tag = 0;
            self.msgField.enabled = false;
            self.sendBtn.enabled = false;
            break;
            
        case GKPeerStateConnecting:
            self.statusField.text = @"Connectiong...";
            break;
            
        case GKPeerStateAvailable:
            self.statusField.text = @"Available";
            break;
            
        case GKPeerStateUnavailable:
            self.statusField.text = @"Unavailable;";
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	NSLog(@"Connection Request From Peer:%@", peerID);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
	NSLog(@"Connection Failed... \n Peer:%@ \n error:%@", peerID, error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	NSLog(@"Session Fail Error... \n error:%@", error);
}

#pragma mark - GKSession setDataReceiveHandler

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSString *msg = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSString *text = [[session displayNameForPeer:peer] stringByAppendingFormat:@" > %@\n%@",msg ,self.txtField.text];
    self.txtField.text = text;
}

#pragma mark - IBAction

- (IBAction)btnConnect:(id)sender {
    if (self.connectBtn.tag == 0) {
        GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
        picker.delegate = self;
        picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
        [picker show];
    } else {
        [currentSession disconnectFromAllPeers];
    }
}

- (IBAction)btnSend:(id)sender {
    NSData *data = [self.msgField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    [self.currentSession sendData:data toPeers:[NSArray arrayWithObject:self.currentPeerID] withDataMode:GKSendDataReliable error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    NSString *text = [[[NSString alloc] initWithFormat:@"me > %@\n%@", self.msgField.text, self.txtField.text] autorelease];
    self.txtField.text = text;
    
    self.msgField.text = @"";

}

#pragma mark - dealloc

- (void)dealloc {
    [txtField release];
    [msgField release];
    [statusField release];
    [connectBtn release];
    [sendBtn release];
    [super dealloc];
}
@end
