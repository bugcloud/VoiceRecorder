//
//  PlayerViewController.h
//  VoiceRecorder
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundList.h"

@class PlayerViewController;
@protocol PlayerViewControllerDelegate
- (void)willPlayerViewDisappear:(PlayerViewController *)controller;
@end

@interface PlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    __unsafe_unretained id<PlayerViewControllerDelegate>delegate;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) SoundList *soundList;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, assign) id<PlayerViewControllerDelegate>delegate;

@end
