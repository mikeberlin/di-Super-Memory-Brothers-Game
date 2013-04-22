//
//  GameViewController.h
//  MemoryCardGame
//
//  Created by Mike Berlin on 4/17/13.
//  Copyright (c) 2013 Mike Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGame.h"

@interface GameViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *UICardCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLabel;

@property (strong, nonatomic) CardGame *game;

- (IBAction)btnTap:(id)sender;
- (IBAction)btnRestartGame:(UIButton *)sender;

@end