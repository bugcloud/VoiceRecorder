//
//  ViewController.h
//  VoiceRecorder
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, weak) IBOutlet UIButton *recordBtn;
@property (nonatomic, weak) IBOutlet UIButton *playBtn;

- (IBAction)recordButtonTouchStart:(UIButton *)btn;
- (IBAction)recordButtonTouchEnd:(UIButton *)btn;
- (IBAction)playButtonTouchEnd:(UIButton *)btn;

@end
