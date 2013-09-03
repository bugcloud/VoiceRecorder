//
//  PlayerViewController.m
//  VoiceRecorder
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        _soundList = [[SoundList alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(
                                                               0,
                                                               44,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - 44
                                                               )];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // show navigation Bar
    NSDictionary *navBarTextAttributes = @{
                                           UITextAttributeTextColor: UIColorFromRGB(0x8f8f8f),
                                           UITextAttributeTextShadowColor: [UIColor clearColor],
                                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)]
                                           };
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0xf8f8f8)];
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTextAttributes];
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Play Records"];
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTouched:)];
    [closeBtn setTitleTextAttributes:navBarTextAttributes forState:UIControlStateNormal];
    item.rightBarButtonItem = closeBtn;
    [navBar pushNavigationItem:item animated:NO];
    [self.view addSubview:navBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)closeButtonTouched:(id)sender
{
    [self.delegate willPlayerViewDisappear:self];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_soundList.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"TableCellID";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [cell.textLabel setText:[formatter stringFromDate:[_soundList.list[indexPath.row] createdAt]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_soundList remove:indexPath.row];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
    NSError *error = nil;
    
    // File Path
    NSString *filePath = [_soundList.list[indexPath.row] filePath];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error != nil) {
            LOG(@"Error %@", [error localizedDescription]);
            return;
        }
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error != nil) {
            LOG(@"Error %@", [error localizedDescription]);
            return;
        }
        [_player prepareToPlay];
        [_player play];
    }
}

@end
