//
//  ViewController.h
//  VoiceRecorder
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerViewController.h"

@interface ViewController : UIViewController <PlayerViewControllerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, retain) PlayerViewController *playerView;
@property (nonatomic, weak) IBOutlet UIButton *recordBtn;
@property (nonatomic, weak) IBOutlet UIButton *playBtn;

- (IBAction)recordButtonTouchStart:(UIButton *)btn;
- (IBAction)recordButtonTouchEnd:(UIButton *)btn;
- (IBAction)playButtonTouchEnd:(UIButton *)btn;

@end
