//
//  wellcomeViewController.m
//  Belled
//
//  Created by Bellnet on 14-9-1.
//  Copyright (c) 2014年 Belled. All rights reserved.
//

#import "wellcomeViewController.h"

@interface wellcomeViewController ()
{

    ICETutorialController *newviewController;
    NSArray *tutorialLayers;

}
@end

@implementation wellcomeViewController


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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *well = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"wellcome"]];
    NSLog(@"changePage %@",well);
    if([well isEqualToString:@""]||[well isEqualToString:@"(null)"]){
    }else{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changePage) userInfo:nil repeats:NO];
    }
    
    
    [self wellcome];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)wellcome
{
    // Init the pages texts, and pictures.
    //ICETutorialController *newviewController = [[ICETutorialController alloc]init];
    
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 1"
                                                            description:@"1"
                                                            pictureName:@"app1_1136@2x.png"];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 2"
                                                            description:@"2"
                                                            pictureName:@"app2_1136@2x.png"];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 3"
                                                            description:@"3"
                                                            pictureName:@"app3_1136@2x.png"];
    ICETutorialPage *layer4 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 4"
                                                            description:@"4"
                                                            pictureName:@"app4_1136@2x.png"];
    
    
    ICETutorialPage *layer11 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 1"
                                                            description:@"1"
                                                            pictureName:@"app1_960@2x.png"];
    ICETutorialPage *layer12 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 2"
                                                            description:@"2"
                                                            pictureName:@"app2_960@2x.png"];
    ICETutorialPage *layer13 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 3"
                                                            description:@"3"
                                                            pictureName:@"app3_960@2x.png"];
    ICETutorialPage *layer14 = [[ICETutorialPage alloc] initWithSubTitle:@"Picture 4"
                                                            description:@"4"
                                                            pictureName:@"app4_960@2x.png"];
    
    // Set the common style for SubTitles and Description (can be overrided on each page).
    /*ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
     [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
     [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
     [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
     [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
     
     ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
     [descStyle setFont:TUTORIAL_DESC_FONT];
     [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
     [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
     [descStyle setOffset:TUTORIAL_DESC_OFFSET];*/
    
    ICETutorialLabelStyle *imgStyle = [[ICETutorialLabelStyle alloc] init];
    [imgStyle setFont:TUTORIAL_DESC_FONT];
    
    // Load into an array.
    
    if(DEVICE_IS_IPHONE5){
       tutorialLayers = @[layer1,layer2,layer3,layer4];
        NSLog(@"5s");
    }else{
       tutorialLayers = @[layer11,layer12,layer13,layer14];
        NSLog(@"4s");
    }
    
    // Override point for customization after application launch.
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     self.viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone"
     bundle:nil
     andPages:tutorialLayers];
     } else {
     self.viewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPad"
     bundle:nil
     andPages:tutorialLayers];
     }*/
    newviewController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone" bundle:nil andPages:tutorialLayers];
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
    //[newviewController setCommonPageSubTitleStyle:subStyle];
    //[newviewController setCommonPageDescriptionStyle:descStyle];
    
    // Set button 1 action.
    [newviewController setButton1Block:^(UIButton *button){
        NSLog(@"Button 1 pressed.");
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"ok" forKey:@"wellcome"];
        [ud synchronize];
        
        [self changePage];
        
    }];
    
    
    // Run it.
    [newviewController startScrolling];
    if(DEVICE_IS_IPHONE5){
        [newviewController.view  setFrame:CGRectMake(0,0,320,568)];
    }else{
        [newviewController.view  setFrame:CGRectMake(0,0,320,480)];
    }
    [self.view addSubview:newviewController.view];
    //self.view =[newviewController copy];
}

-(void)changePage
{
    UINavigationController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"indexView"];
    
    [self presentModalViewController:tmpEdit animated:NO];
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

@end
