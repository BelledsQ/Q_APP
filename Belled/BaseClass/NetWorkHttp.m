//
//  NetWorkHttp.m
//  Belled
//
//  Created by Bellnet on 14-4-17.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "NetWorkHttp.h"

@implementation NetWorkHttp


+(NSString *)httpGet:(NSString *)cmd Postdata:(NSString *)postdata
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?cmd=%@&postdata=%@",__HOSTNAME__,cmd,postdata];
    
    NSLog(@"HTTP Send : %@",urlString);
    
    //NSURL *url = [NSURL URLWithString:urlString];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:url];
    
	[httpRequest setTimeOutSeconds:30];
    
	[httpRequest startSynchronous];
    
	if([httpRequest error]){
        
		NSLog(@"HTTP Equest Fail: %@",[[httpRequest error] description]);
		return @"999";
        
	}else {
		NSString *resultString 	= [httpRequest responseString];
        
		//NSLog(@"HTTP Request : %@",resultString);
        
		NSString *newResultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        return newResultString;
	}
}

+(NSString *)httpPost:(NSString *)cmd Postdata:(NSString *)postdata Files:(NSString *)files
{
    
    //NSString *fileName = [[NSBundle mainBundle] pathForResource:@"speaker_0" ofType:@"png"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",__HOSTNAME__];
    
    NSLog(@"HTTP Send : %@ cmd:%@  postdata:%@  files:%@",urlString,cmd,postdata,files);
    
    //NSURL *url = [NSURL URLWithString:urlString];
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:url];
    
    httpRequest.requestMethod = @"POST";
    
    [httpRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    [httpRequest setPostValue:cmd forKey:@"cmd"];
    
    [httpRequest setPostValue:postdata forKey:@"postdata"];
    
    [httpRequest setFile:files forKey:@"files"];
    
    [httpRequest setTimeOutSeconds:600];
    
    [httpRequest startSynchronous];
    
	if([httpRequest error]){
        
		NSLog(@"HTTP Equest Fail: %@",[[httpRequest error] description]);
		return @"999";
        
	}else {
		NSString *resultString 	= [httpRequest responseString];
        
		NSLog(@"HTTP Request : %@",resultString);
        
		NSString *newResultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
		//NSLog(@"==***%@=%@",newResultString,[newResultString substringToIndex:2]);
        return newResultString;
	}
}

+(NSString *)httpGet_SC:(NSString *)cmd
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",cmd];
    
    NSLog(@"HTTP Send : %@",urlString);
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:url];
    
	[httpRequest setTimeOutSeconds:60];
    
	[httpRequest startSynchronous];
    
	if([httpRequest error]){
        
		NSLog(@"HTTP Equest Fail: %@",[[httpRequest error] description]);
		return @"999";
        
	}else {
		NSString *resultString 	= [httpRequest responseString];
        
		NSLog(@"HTTP Request : %@",resultString);
        
		NSString *newResultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        return newResultString;
	}
}

//decoded之后，解析Json格式
+(NSMutableDictionary *)httpjsonParser:(NSString *)jsonString
{
    //NSLog(@"init : %@",jsonString);
    NSString *decoded = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"decoded : %@",decoded);
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    NSError * error = nil;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[parser objectWithString:decoded error:&error]];
    
    //NSString *jsonToString = [[[SBJsonWriter alloc] init] stringWithObject:dictionary];
    //NSLog(@"jsonToString : %@",jsonToString);
    
    return dictionary;
}

//decoded之后，解析Json格式
+(NSArray *)arrjsonParser:(NSString *)jsonString
{
    //NSLog(@"init : %@",jsonString);
    NSString *decoded = [jsonString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"decoded : %@",decoded);
    
    SBJsonParser * parser = [[SBJsonParser alloc] init];
    NSError * error = nil;
    NSArray *array = [[NSArray alloc] initWithArray:[parser objectWithString:decoded error:&error]];
    
    //NSString *jsonToString = [[[SBJsonWriter alloc] init] stringWithObject:dictionary];
    //NSLog(@"jsonToString : %@",jsonToString);
    
    return array;
}


//测试数组解析
+(void)loginJsonParser:(NSString *)jsonString
{

    NSMutableDictionary *dictionary = [self httpjsonParser:jsonString];

    NSString * res = [dictionary objectForKey:@"res"];
    NSString * msg = [dictionary objectForKey:@"msg"];
    NSString * username = [dictionary objectForKey:@"username"];
    NSString * username_id = [dictionary objectForKey:@"username_id"];
    NSString * accesstoken = [dictionary objectForKey:@"accesstoken"];
    NSLog(@"res : %@",res);
    NSLog(@"msg : %@",msg);
    NSLog(@"username : %@",username);
    NSLog(@"username_id : %@",username_id);
    NSLog(@"accesstoken : %@",accesstoken);
    NSLog(@"dictionary : %@",dictionary);
    
    //NSMutableArray * jsondata = [jsonToString JSONValue];
   
    /*for(NSMutableDictionary * dictionary  in jsondata)
    {
        NSLog(@"res : %@,msg : %@,username : %@,username_id : %@,accesstoken : %@",[dictionary objectForKey:@"res"],[dictionary objectForKey:@"msg"],[dictionary objectForKey:@"username"],[dictionary objectForKey:@"username_id"],[dictionary objectForKey:@"accesstoken"]);
    }*/
}



@end

