//
//  HomeViewController.m
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/19/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HomeViewController.h"
#import "GameViewController.h"
#import "HighScoresViewController.h"

@interface HomeViewController ()
{
    AVAudioPlayer *audioPlayer;
}
@end

@implementation HomeViewController

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

    self.lblGameTitle.font = [UIFont fontWithName:@"Super Plumber Brothers" size:32];
    self.lblStartGame.titleLabel.font = [UIFont fontWithName:@"Emulogic" size:12];
    self.lblViewHighScores.titleLabel.font = [UIFont fontWithName:@"Emulogic" size:12];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self playTitleMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Events

- (IBAction)btnStartGame:(UIButton *)sender
{
    [self stopTitleMusic];

    GameViewController *vcGame = [[GameViewController alloc] init];
    [self presentViewController:vcGame animated:YES completion:Nil];
}

- (IBAction)btnViewHighScores:(UIButton *)sender
{
    [self stopTitleMusic];
    
    HighScoresViewController *vcHighScores = [[HighScoresViewController alloc] init];
    [self presentViewController:vcHighScores animated:YES completion:Nil];
}

#pragma mark - Private Methods

- (void)stopTitleMusic
{
    [audioPlayer stop];
}

- (void)playTitleMusic
{
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource:@"Overworld"
                                    ofType:@"mp3"];

    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                         error:nil];

    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
}

@end