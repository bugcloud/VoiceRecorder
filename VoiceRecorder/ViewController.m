//
//  ViewController.m
//  VoiceRecorder
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ViewController" bundle:nil];
    if (self) {
        _session = [AVAudioSession sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)recordButtonTouchStart:(UIButton *)btn
{
    NSError *error = nil;
    if (_session.inputAvailable) {
        [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    }
    if (error != nil) {
        LOG(@"Error when preparing audio session :%@", [error localizedDescription]);
        return;
    }
    
    [_session setActive:YES error:&error];
    if (error != nil) {
        LOG(@"Error when enabling audio session :%@", [error localizedDescription]);
        return;
    }
    
    // make file path & start recording
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:&error];
    if (error != nil) {
        LOG(@"Error when preparing audio session :%@", [error localizedDescription]);
        return;
    }
    [_recorder record];
}

- (IBAction)recordButtonTouchEnd:(UIButton *)btn
{
    if (_recorder != nil && _recorder.isRecording) {
        [_recorder stop];
        _recorder = nil;
    }
}

- (IBAction)playButtonTouchEnd:(UIButton *)btn
{
    NSError *error = nil;
    
    // File Path
    NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [dir stringByAppendingPathComponent:@"test.caf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (error != nil) {
            LOG(@"Error %@", [error localizedDescription]);
        }
        [_player prepareToPlay];
        [_player play];
    }
}

@end
