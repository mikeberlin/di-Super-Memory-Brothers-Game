//
//  HomeViewController.h
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/19/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblGameTitle;
@property (weak, nonatomic) IBOutlet UIButton *lblStartGame;
@property (weak, nonatomic) IBOutlet UIButton *lblViewHighScores;

- (IBAction)btnStartGame:(UIButton *)sender;
- (IBAction)btnViewHighScores:(UIButton *)sender;

@end