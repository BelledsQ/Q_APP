//
//  EditAlarmViewController.m
//  Belled
//
//  Created by Bellnet on 14/10/21.
//  Copyright (c) 2014年 Belled. All rights reserved.
//

#import "EditAlarmViewController.h"

@interface EditAlarmViewController ()

@end

@implementation EditAlarmViewController
{
    GlobalSet *gt;
    MBProgressHUD *HUD;
    NSMutableArray *datasource;
    NSMutableString *weeks_onoff;
    NSMutableString *title_onoff;
    NSMutableString *light_onoff;
    NSMutableString *music_onoff;
    NSMutableString *alarm_onoff;
    int m1;
    int m2;
    int m3;
    int m4;
    int m5;
    int m6;
    int m7;
    BOOL *w1;
    BOOL *w2;
    BOOL *w3;
    BOOL *w4;
    BOOL *w5;
    BOOL *w6;
    BOOL *w7;
    
    NSMutableString *w1s;
    NSMutableString *w2s;
    NSMutableString *w3s;
    NSMutableString *w4s;
    NSMutableString *w5s;
    NSMutableString *w6s;
    NSMutableString *w7s;
    
    NSMutableString *weeksStr;
    NSMutableString *weeksStrs;
    
    NSMutableString *musicStr;
    NSMutableString *alarmStr;
    NSMutableString *controlStr;
    NSMutableString *dateStr;
    NSMutableString *timezoneStr;
    
    UIButton *btnView1;
    UIButton *btnView2;
    UIButton *btnView3;
    UIButton *btnView4;
    UIButton *btnView5;
    UIButton *btnView6;
    UIButton *btnView7;
    
    UITextField *alarmtitle;
    NSString *alarmtitles;
    
    UIColor *c1;
    UIColor *c2;
    UIColor *c3;
    UIColor *c4;
    UIColor *c5;
    UIColor *c6;
    UIColor *c7;
}
@synthesize  scantableView,datasource,celloptions,window,infoLabel,dataPicker,atitle,aid,aactiontime,acontrol,aweeks,atimezone;

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
    
    //NSString *acontrolstring = [[NSString alloc] initWithFormat:@"%@",acontrol];
    //NSArray *acontrolsarray = [acontrolstring componentsSeparatedByString:@","];
    
    alarmtitles = [[NSMutableString alloc] initWithFormat:@"%@",atitle];
    //controlStr = [[NSMutableString alloc] initWithFormat:@"%@,%@,%@,0,0",[acontrolsarray objectAtIndex:0],[acontrolsarray objectAtIndex:1],[acontrolsarray objectAtIndex:2]];
    controlStr =  [[NSMutableString alloc] initWithFormat:@"%@",acontrol];
    NSLog(@"controlStr::%@",controlStr);
    
    weeksStr = [[NSMutableString alloc] initWithFormat:@"%@",aweeks];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    [self dateTimes];
    NSLog(@"timezoneStr %@",timezoneStr);
    
    [dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    NSString *string = [[NSString alloc] initWithFormat:@"%@",aweeks];
    NSArray *weeksarray = [string componentsSeparatedByString:@","];
    //NSLog(@"%@",[weeksarray objectAtIndex:0]);
    m1 = 0;
    m2 = 0;
    m3 = 0;
    m4 = 0;
    m5 = 0;
    m6 = 0;
    m7 = 0;
    if([[weeksarray objectAtIndex:0] isEqualToString:@"0"]){
        w1 = false;
    }else{
        w1 = true;
    }
    
    if([[weeksarray objectAtIndex:1] isEqualToString:@"0"]){
        w2 = false;
    }else{
        w2 = true;
    }
    
    if([[weeksarray objectAtIndex:2] isEqualToString:@"0"]){
        w3 = false;
    }else{
        w3 = true;
    }
    
    if([[weeksarray objectAtIndex:3] isEqualToString:@"0"]){
        w4 = false;
    }else{
        w4 = true;
    }
    
    if([[weeksarray objectAtIndex:4] isEqualToString:@"0"]){
        w5 = false;
    }else{
        w5 = true;
    }
    
    if([[weeksarray objectAtIndex:5] isEqualToString:@"0"]){
        w6 = false;
    }else{
        w6 = true;
    }
    
    if([[weeksarray objectAtIndex:6] isEqualToString:@"0"]){
        w7 = false;
    }else{
        w7 = true;
    }
    
    w1s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:0]];
    w2s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:1]];
    w3s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:2]];
    w4s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:3]];
    w5s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:4]];
    w6s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:5]];
    w7s = [[NSMutableString alloc] initWithFormat:@"%@",[weeksarray objectAtIndex:6]];
    
    // Do any additional setup after loading the view.
    
    light_onoff = [[NSMutableString alloc] initWithFormat:@"%@",controlStr];
    music_onoff = [[NSMutableString alloc] initWithString:@"OFF"];
    alarm_onoff = [[NSMutableString alloc] initWithString:@"ON"];
    
    
    [self getDatas];
    
    scantableView.delegate = self;
    scantableView.dataSource = self;
    
    //[self getweekData];
    
    UIBarButtonItem *lButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack)];
    self.navigationItem.leftBarButtonItem = lButton;
    
    
    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doSubmit)];
    self.navigationItem.rightBarButtonItem = cButton;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(lightOnOffData)
                                                name:@"reRoadAlarmLight"//消息名
                                              object:nil];//注意是nil
    
    /*[[NSNotificationCenter defaultCenter]addObserver:self
     selector:@selector(titleOnOffData)
     name:@"reRoadAlarmTitle"//消息名
     object:nil];//注意是nil*/
}

-(void)dateTimes{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter* zoneFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
    //NSTimeZone *timezone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timezone];
    [dateFormatter setDateFormat:@"HH:mm"]; // 这里是用大写的 H
    [zoneFormatter setDateFormat:@"Z"]; // 这里是用大写的 H
    NSString* dateS = [dateFormatter stringFromDate:dataPicker.date];
    NSString* zoneS = [zoneFormatter stringFromDate:dataPicker.date];
    dateStr = [[NSMutableString alloc] initWithFormat:@"%@",dateS];
    timezoneStr = [[NSMutableString alloc] initWithFormat:@"%@",zoneS];
    NSLog(@"%@",dataPicker.date);
    NSLog(@"time:%@ zone:%@",dateStr,timezoneStr);
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter* zoneFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 这里是用大写的 H
    //NSTimeZone *timezone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSTimeZone *timezone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timezone];
    [dateFormatter setDateFormat:@"HH:mm"]; // 这里是用大写的 H
    [zoneFormatter setDateFormat:@"Z"]; // 这里是用大写的 H
    NSString* dateS = [dateFormatter stringFromDate:control.date];
    NSString* zoneS = [zoneFormatter stringFromDate:control.date];
    dateStr = [[NSMutableString alloc] initWithFormat:@"%@",dateS];
    timezoneStr = [[NSMutableString alloc] initWithFormat:@"%@",zoneS];
    NSLog(@"%@",control.date);
    NSLog(@"time:%@ zone:%@",dateStr,timezoneStr);
    
    /*添加你自己响应代码*/
}

/*-(void)getweekData
 {
 
 celloptions = [[NSMutableArray arrayWithObjects:
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w1,@"ischeck",@"Monday",@"text", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w2,@"ischeck",@"Tuesday",@"text", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w3,@"ischeck",@"Wednesday",@"text", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w4,@"ischeck",@"Thursday",@"text", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w5,@"ischeck",@"Friday",@"text", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w6,@"ischeck",@"Saturday",@"text", nil],
 [NSMutableDictionary dictionaryWithObjectsAndKeys:w7,@"ischeck",@"Sunday",@"text", nil],
 nil] retain];
 
 }*/

-(void)getDatas{
    
    NSMutableDictionary *week = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Week",@"title", nil];
    NSMutableDictionary *title = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Title",@"title",nil];
    NSMutableDictionary *light = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Light",@"title",light_onoff,@"onoff", nil];
    datasource = [[NSMutableArray alloc] initWithObjects:week,title,light,nil];
}

-(void)doClickedBack
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reRoadTableViewAlarmid" object:self];
}

-(void)doSubmit
{
    //全局变量
    
    gt = [GlobalSet bellSetting];
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpAlarmadd];
    NSString *res = [res_dictionary objectForKey:@"res"];
    
    if([res isEqualToString:@"200"]){
        //成功
        [Tools showMsg:@"OK" message:@"SUCCESS!"];
    }else if([res isEqualToString:@"100"]){
        //失败
        [Tools showMsg:@"Warning" message:@"Miss"];
    }else{
        //服端端或网络异常
        [Tools showMsg:@"Warning" message:@"Network is error."];
    }
    [HUD hide:YES];
    [self doClickedBack];
    NSLog(@"res_dictionary :%@",res_dictionary);
    
}

-(NSMutableDictionary *)httpAlarmadd
{
    gt = [GlobalSet bellSetting];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"alarm_edit"];
    if([gt.alarmTitle isEqualToString:@""] || [dateStr isEqualToString:@""]){
        [Tools showMsg:@"Warning" message:@"Title is NUll or AlarmTime"];
    }else{
        //封装mutableDictionary
        NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",aid,@"alarmid",alarmtitle.text,@"title",dateStr,@"actiontime",timezoneStr,@"timezone",controlStr,@"control",weeksStr,@"weeks",nil];
        //mutableDictionary转NSString
        NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:postdata];
        NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
        //NSLog(@"resdata:%@",resdata);
        if([resdata isEqualToString:@"999"]==false){
            res_dictionary = [NetWorkHttp httpjsonParser:resdata];
        }
        
    }
    return res_dictionary;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) lightOnOffData
{
    gt = [GlobalSet bellSetting];
    NSString *switchstr = [[NSString alloc]init];
    NSString *rgbstr = [[NSString alloc]init];
    if([gt.alarmLight_switch isEqualToString:@"1"]){
        switchstr = [[NSString alloc] initWithFormat:@"%@",@"ON"];
    }else{
        switchstr = [[NSString alloc] initWithFormat:@"%@",@"OFF"];
    }
    rgbstr = [[NSString alloc]initWithFormat:@"R:%@ G:%@ B:%@",gt.alarmLight_red,gt.alarmLight_green,gt.alarmLight_blue];
    
    light_onoff = [[NSMutableString alloc] initWithFormat:@"%@ %@ %@",switchstr,rgbstr,gt.alarmLight_bright];
    
    controlStr = [[NSMutableString alloc] initWithFormat:@"%@,%@:%@:%@,%@,0,0",gt.alarmLight_switch,gt.alarmLight_red,gt.alarmLight_green,gt.alarmLight_blue,gt.alarmLight_bright];
    [self reRoadTableView];
}

-(void) titleOnOffData
{
    gt = [GlobalSet bellSetting];
    title_onoff = [[NSMutableString alloc] initWithFormat:@"%@",gt.alarmTitle];
    [self reRoadTableView];
}

- (void) reRoadTableView
{
    scantableView.delegate = self;
    scantableView.dataSource = self;
    [self getDatas];
    [self.scantableView reloadData];
}

//Delegate tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    //NSLog(@"rows : %d",[data count]);
    return [datasource count];
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlarmAddCell";
    AlarmTableViewCell *cell = (AlarmTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //---------- CELL BACKGROUND IMAGE -----------------------------
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    //UIImage *image = [UIImage imageNamed:@"LightGrey@2x.png"];
    //imageView.image = image;
    //cell.backgroundView = imageView;
    //[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    //[[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    
    //NSString *datarow = [[NSString alloc] init];
    
    //NSString *rows = [NSString stringWithFormat:@"%d",indexPath.row];
    
    //NSLog(@"rows : %@",rows);
    datarow = [datasource objectAtIndex:indexPath.row];
    
    if(indexPath.row==0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.onoff.hidden =YES;
        if(w1){
            c1 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c1 = [UIColor grayColor];
        }
        
        if(w2){
            c2 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c2 = [UIColor grayColor];
        }
        
        if(w3){
            c3 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c3 = [UIColor grayColor];
        }
        
        if(w4){
            c4 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c4 = [UIColor grayColor];
        }
        
        if(w5){
            c5 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c5 = [UIColor grayColor];
        }
        
        if(w6){
            c6 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c6 = [UIColor grayColor];
        }
        
        if(w7){
            c7 = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        }else{
            c7 = [UIColor grayColor];
        }
        
        btnView1 = [[UIButton alloc] initWithFrame:CGRectMake(65,10,30,24)];
        [btnView1 setTitle:@"Mon" forState:UIControlStateNormal];
        btnView1.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView1 setBackgroundColor:c1];
        [btnView1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView1];
        
        btnView2 = [[UIButton alloc] initWithFrame:CGRectMake(100,10,30,24)];
        [btnView2 setTitle:@"Tue" forState:UIControlStateNormal];
        btnView2.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView2 setBackgroundColor:c2];
        [btnView2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView2];
        
        btnView3 = [[UIButton alloc] initWithFrame:CGRectMake(135,10,30,24)];
        [btnView3 setTitle:@"Wed" forState:UIControlStateNormal];
        btnView3.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView3 setBackgroundColor:c3];
        [btnView3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView3];
        
        btnView4 = [[UIButton alloc] initWithFrame:CGRectMake(170,10,30,24)];
        [btnView4 setTitle:@"Thu" forState:UIControlStateNormal];
        btnView4.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView4 setBackgroundColor:c4];
        [btnView4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView4];
        
        btnView5 = [[UIButton alloc] initWithFrame:CGRectMake(205,10,30,24)];
        [btnView5 setTitle:@"Fri" forState:UIControlStateNormal];
        btnView5.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView5 setBackgroundColor:c5];
        [btnView5 addTarget:self action:@selector(clickBtn5) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView5];
        
        btnView6 = [[UIButton alloc] initWithFrame:CGRectMake(240,10,30,24)];
        [btnView6 setTitle:@"Sat" forState:UIControlStateNormal];
        btnView6.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView6 setBackgroundColor:c6];
        [btnView6 addTarget:self action:@selector(clickBtn6) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView6];
        
        btnView7 = [[UIButton alloc] initWithFrame:CGRectMake(275,10,30,24)];
        [btnView7 setTitle:@"Sun" forState:UIControlStateNormal];
        btnView7.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [btnView7 setBackgroundColor:c7];
        [btnView7 addTarget:self action:@selector(clickBtn7) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnView7];
        
    }
    
    if(indexPath.row==1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        alarmtitle = [[UITextField alloc] initWithFrame:CGRectMake(125,8,180,26)];
        alarmtitle.returnKeyType = UIReturnKeyDone;
        alarmtitle.clearButtonMode = UITextFieldViewModeWhileEditing;
        alarmtitle.delegate = self;
        alarmtitle.font = [UIFont systemFontOfSize:12];
        [alarmtitle setBorderStyle:UITextBorderStyleRoundedRect];
        alarmtitle.text = alarmtitles;
        [cell.contentView addSubview:alarmtitle];
    }
    
    if(indexPath.row==2){
        //Arrow
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.sn.text = [datarow objectForKey:@"title"];
    cell.onoff.text = [datarow objectForKey:@"onoff"];
    
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        //[self showListView];
        
    }
    
    if(indexPath.row == 1)
    {
        // TitleViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"alarm_titleView"];
        //[self.navigationController pushViewController:detail animated:YES];
    }
    
    if(indexPath.row == 2)
    {
        alarmtitles = [[NSString alloc] initWithFormat:@"%@",alarmtitle.text];
        LightConViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"lightdetail"];
        detail.sn = @"Light";
        detail.contrlType = @"3";
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    /*if(indexPath.row == 3)
     {
     if([music_onoff isEqualToString:@"OFF"]){
     music_onoff = [[NSMutableString alloc]initWithString:@"ON"];
     musicStr = [[NSMutableString alloc]initWithString:@"1"];
     }else{
     music_onoff = [[NSMutableString alloc]initWithString:@"OFF"];
     musicStr = [[NSMutableString alloc]initWithString:@"0"];
     }
     
     [self reRoadTableView];
     }*/
    
}

- (void)showListView
{
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"Week Selcet" options:celloptions];
    lplv.delegate = self;
    [lplv showInView:self.view animated:YES];
}

- (void)clickBtnWeek:(NSInteger)anIndex
{
    NSLog(@"%d",anIndex);
    switch(anIndex)
    {
        case 0:
            if(w1){
                w1s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w1s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
            
        case 1:
            if(w2){
                w2s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w2s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
            
        case 2:
            if(w3){
                w3s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w3s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
            
        case 3:
            if(w4){
                w4s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w4s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
            
        case 4:
            if(w5){
                w5s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w5s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
            
        case 5:
            if(w6){
                w6s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w6s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
            
        case 6:
            if(w7){
                w7s = [[NSMutableString alloc] initWithFormat:@"%@",@"1"];
            }else{
                w7s = [[NSMutableString alloc] initWithFormat:@"%@",@"0"];
            }
            break;
    }
    weeksStr = [[NSMutableString alloc] initWithFormat:@"%@,%@,%@,%@,%@,%@,%@",w1s,w2s,w3s,w4s,w5s,w6s,w7s];
    
    //gt.alarmWeek = [weeksStr copy];
    NSLog(@"week %@",weeksStr);
    
}

-(int)checkSelect:(int)v value:(int)vo
{
    int n;
    if(v%2==0){
        n = 1;
    }else{
        n = 0;
    }
    switch(vo)
    {
        case 1:
            m1++;
            break;
            
        case 2:
            m2++;
            break;
            
        case 3:
            m3++;
            break;
            
        case 4:
            m4++;
            break;
            
        case 5:
            m5++;
            break;
            
        case 6:
            m6++;
            break;
            
        case 7:
            m7++;
            break;
            
    }
    return n;
}

-(void)clickBtn1
{
    if(w1){
        UIColor *color = [UIColor grayColor];
        [btnView1 setBackgroundColor:color];
        w1 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView1 setBackgroundColor:color];
        w1 = true;
    }
    [self clickBtnWeek:0];
}

-(void)clickBtn2
{
    if(w2){
        UIColor *color = [UIColor grayColor];
        [btnView2 setBackgroundColor:color];
        w2 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView2 setBackgroundColor:color];
        w2 = true;
    }
    [self clickBtnWeek:1];
}

-(void)clickBtn3
{
    if(w3){
        UIColor *color = [UIColor grayColor];
        [btnView3 setBackgroundColor:color];
        w3 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView3 setBackgroundColor:color];
        w3 = true;
    }
    [self clickBtnWeek:2];
}

-(void)clickBtn4
{
    if(w4){
        UIColor *color = [UIColor grayColor];
        [btnView4 setBackgroundColor:color];
        w4 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView4 setBackgroundColor:color];
        w4 = true;
    }
    [self clickBtnWeek:3];
}

-(void)clickBtn5
{
    if(w5){
        UIColor *color = [UIColor grayColor];
        [btnView5 setBackgroundColor:color];
        w5 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView5 setBackgroundColor:color];
        w5 = true;
    }
    [self clickBtnWeek:4];
}

-(void)clickBtn6
{
    if(w6){
        UIColor *color = [UIColor grayColor];
        [btnView6 setBackgroundColor:color];
        w6 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView6 setBackgroundColor:color];
        w6 = true;
    }
    [self clickBtnWeek:5];
}

-(void)clickBtn7
{
    if(w7){
        UIColor *color = [UIColor grayColor];
        [btnView7 setBackgroundColor:color];
        w7 = false;
    }else{
        UIColor *color = [UIColor colorWithRed:0/255.0 green:90/255.0 blue:255/255.0 alpha:1.0];
        [btnView7 setBackgroundColor:color];
        w7 = true;
    }
    [self clickBtnWeek:6];
}

/*- (void)leveyPopListViewDidCancel
 {
 [self getweekData];
 weeks_onoff = [weeksStrs copy];
 [self reRoadTableView];
 //NSLog(@"finnall");
 }*/

//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
