//
//  TitleViewController.m
//  Belled
//
//  Created by Bellnet on 14-7-14.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "TitleViewController.h"

@interface TitleViewController ()

@end

@implementation TitleViewController

@synthesize  alarmTitle;

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
    // Do any additional setup after loading the view.
    alarmTitle.delegate = self;
    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack)];
    self.navigationItem.leftBarButtonItem = cButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submitTitle
{
    //全局变量
    GlobalSet *gt = [GlobalSet bellSetting];
    gt.alarmTitle = alarmTitle.text;
    NSLog(@"%@",gt.alarmTitle);
}

//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) doClickedBack
{
    [self.navigationController popViewControllerAnimated:YES];
    //NSLog(@"showTabBar");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reRoadAlarmTitle" object:self];
}
@end
