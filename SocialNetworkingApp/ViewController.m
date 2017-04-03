//
//  ViewController.m
//  SocialNetworkingApp
//
//  Created by Yana Morenko on 4/2/17.
//  Copyright © 2017 MaryyannaDevelopment. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor lightGrayColor];
    [self configureTextViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions -
-(void) configureTextViews {
    self.messageTextView.text = @"This text I want to share with the world.";
    self.messageTextView.textColor = [UIColor redColor];
    self.messageTextView.layer.backgroundColor = [[UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0] CGColor];
    self.messageTextView.layer.cornerRadius = 10.0f;
    self.messageTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.messageTextView.layer.borderWidth = 2.0f;
}

-(void) showAlertMessage:(NSString *) thisMessage {
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Social Share" message:thisMessage preferredStyle:UIAlertControllerStyleAlert];
    [actionController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionController animated:YES completion:nil];
}

- (IBAction)shareButonAction:(id)sender {
    //shut keyboard
    if ([self.messageTextView isFirstResponder]) {
        [self.messageTextView resignFirstResponder];
    }
    
    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"Social Share" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionController addAction:cancelAction];
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:
                                  ^(UIAlertAction *action){
                                      //if user is signed in Twitter
                                      if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                                          //create twitter controller
                                          SLComposeViewController *twitterVC = [SLComposeViewController  composeViewControllerForServiceType:SLServiceTypeTwitter];
                                          //tweet message is limited by 140 characters
                                          if (self.messageTextView.text.length <= 140) {
                                              [twitterVC setInitialText:self.messageTextView.text];
                                          }
                                          else {
                                              NSString *shortText = [self.messageTextView.text substringToIndex:140];
                                              [twitterVC setInitialText:shortText];
                                          }
                                          //show twitter controller
                                          [self presentViewController:twitterVC animated:YES completion:nil];
                                      }
                                      else{
                                          [self showAlertMessage:@"Please sign in to Twitter before you tweet."];
                                      }
                                  }];
    [actionController addAction:tweetAction];
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:
                                     ^(UIAlertAction *action) {
                                         //check user is signed in Facebook
                                         if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
                                             //create facebook controller
                                             SLComposeViewController *facebookVC = [SLComposeViewController  composeViewControllerForServiceType:SLServiceTypeFacebook];
                                             [facebookVC setInitialText:self.messageTextView.text];
                                             //show twitter controller
                                             [self presentViewController:facebookVC animated:YES completion:nil];
                                         }
                                         else{
                                             [self showAlertMessage:@"Please sign in to Facebook before you post."];
                                         }
                                     }];
    [actionController addAction:facebookAction];
    //share with any social media (undefined)
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"More" style:UIAlertActionStyleDefault handler:
                                     ^(UIAlertAction *action) {
                                         UIActivityViewController *moreVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.messageTextView.text] applicationActivities:nil];
                                         [self presentViewController:moreVC animated:YES completion:nil];
                                     }];
    [actionController addAction:moreAction];
    [self presentViewController:actionController animated:YES completion:nil];
}



@end
