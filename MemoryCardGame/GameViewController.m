//
//  GameViewController
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/17/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GameViewController.h"
#import "CardGame.h"
#import "PlayingCard.h"
#import "HighScoresViewController.h"

#define WINNER_DISMISS_BUTTON_TEXT @"Fantastic!"
#define HIGH_SCORE_ENTRY_DISMISS_BUTTON_TEXT @"OK"

@interface GameViewController ()
{
    AVAudioPlayer *musicPlayer;
    AVAudioPlayer *soundPlayer;
}

@property (strong, nonatomic) UIAlertView *highScoreNameEntry;
@property (nonatomic) NSTimeInterval playersTime;

@end

@implementation GameViewController

#pragma mark - ViewController Event Model

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.btnStart.titleLabel.font = [UIFont fontWithName:@"Emulogic" size:12];
    self.lblTimeLabel.font = [UIFont fontWithName:@"Emulogic" size:12];
    self.lblTime.font = [UIFont fontWithName:@"Emulogic" size:12];

    [self playGameMusic];
    [self initGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)btnTap:(UIButton *)sender
{
    BOOL matchMade = [self.game flipCardAtIndex:[self.UICardCollection indexOfObject:sender]];
    [self updateUI];
    self.game.NumberOfGuesses++;

    // only play the no match/match sounds after the first guess has been made.
    if (self.game.NumberOfGuesses > 1)
    {
        if (matchMade)
            [self playMatchSound];
        else
            [self playNoMatchSound];
    }
    
    if (self.game.GameWon)
    {
        self.playersTime = [self.game getTimerTimeInterval];
        [self.game.PollingTimer invalidate];
        self.game.PollingTimer = nil;

        [self stopGameMusic];
        [self playSoundName:@"VictoryFanFare" WithType:@"mp3" AndRepeat:NO];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Won!"
                                                        message:@"Congrats on winning!"
                                                       delegate:self
                                              cancelButtonTitle:WINNER_DISMISS_BUTTON_TEXT
                                              otherButtonTitles:Nil, nil];
        [alert show];
    }
}

- (IBAction)btnRestartGame:(UIButton *)sender
{
    [self initGame];
    [self updateUI];
}

#pragma mark - Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:WINNER_DISMISS_BUTTON_TEXT])
    {
        if ([self.game isHighScore:self.playersTime])
        {
            self.highScoreNameEntry = [[UIAlertView alloc] initWithTitle:@"You got a high score!"
                                                                 message:@"Enter your name to be forever immortalized by your greatness."
                                                                delegate:self
                                                       cancelButtonTitle:HIGH_SCORE_ENTRY_DISMISS_BUTTON_TEXT
                                                       otherButtonTitles:Nil, nil];

            self.highScoreNameEntry.alertViewStyle = UIAlertViewStylePlainTextInput;
            ((UITextField *)[self.highScoreNameEntry textFieldAtIndex:0]).placeholder = @"Enter your name";

            [[self.highScoreNameEntry textFieldAtIndex:0] setDelegate:self];
            [self.highScoreNameEntry show];
        }
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:HIGH_SCORE_ENTRY_DISMISS_BUTTON_TEXT])
    {
        [self.game savePlayersTimeToHighScores:self.playersTime withName:[[alertView textFieldAtIndex:0] text]];
        [self showHighScoresView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.highScoreNameEntry dismissWithClickedButtonIndex:self.highScoreNameEntry.firstOtherButtonIndex animated:YES];
    [self.highScoreNameEntry.delegate alertView:self.highScoreNameEntry clickedButtonAtIndex:0];
    return YES;
}

#pragma mark - Private Messages

- (void)initGame
{
    self.game = [[CardGame alloc] init];
    self.playersTime = 0;
    self.lblTime.text = @"00:00";

    self.game.StartTimer = [NSDate date];
    self.game.PollingTimer = [NSTimer scheduledTimerWithTimeInterval:self.game.lengthOfPollingTimer
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.UICardCollection) {
        PlayingCard *card = [self.game cardAtIndex:[self.UICardCollection indexOfObject:cardButton]];
        UIImage *cardImage = (card.IsFaceUp)
                                ? [UIImage imageNamed:card.ImagePath]
                                : [UIImage imageNamed:@"QuestionBlock.png"];

        [cardButton setImage:cardImage forState:UIControlStateNormal];
        cardButton.selected = card.IsFaceUp;
        cardButton.enabled = !card.WasPlayed;
        cardButton.alpha = card.WasPlayed ? 0.3 : 1.0;
    }
}

- (void)updateTimer
{
    self.lblTime.text = [self.game getTimerTimeString];
}

- (void)showHighScoresView
{
    [self stopGameMusic];

    HighScoresViewController *vcHighScores = [[HighScoresViewController alloc] init];
    [self presentViewController:vcHighScores animated:YES completion:Nil];
}

- (void)stopGameMusic
{
    [musicPlayer stop];
}

- (void)playGameMusic
{
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource:@"SpadeGame"
                                    ofType:@"mp3"];

    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                         error:nil];
    musicPlayer.numberOfLoops = -1;
    [musicPlayer play];
}

- (void)playMatchSound
{
    [self playSoundName:@"Match" WithType:@"wav" AndRepeat:NO];
}

- (void)playNoMatchSound
{
    [self playSoundName:@"NoMatch" WithType:@"wav" AndRepeat:NO];
}

- (void)playSoundName:(NSString *)fileName WithType:(NSString *)fileType AndRepeat:(BOOL)loopSound
{
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource:fileName
                                    ofType:fileType];

    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                         error:nil];

    if (loopSound) soundPlayer.numberOfLoops = -1;
    [soundPlayer play];
}

@end