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
    _playerView = [[PlayerViewController alloc] init];
    _playerView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)recordButtonTouchStart:(UIButton *)btn
{
    NSError *error = nil;
    if (_session.inputAvailable) {
        [_session setCategory:AVAudioSessionCategoryRecord error:&error];
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
    Sound *sound = [[Sound alloc] initWithAttributes:@{ @"createdAt": [NSDate date] }];
    NSURL *url = [NSURL fileURLWithPath:sound.filePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:&error];
    if (error != nil) {
        LOG(@"Error when preparing audio session :%@", [error localizedDescription]);
        return;
    }
    [_playerView.soundList append:sound];
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
    [self presentViewController:_playerView animated:YES completion:^(void) {
        [_playerView.tableView reloadData];
    }];
}

#pragma mark -
#pragma mark PlayerViewDelegate
- (void)willPlayerViewDisappear:(PlayerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^(void) {}];
}

@end
