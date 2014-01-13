//
//  RootTableVC.m
//  ASIHTTPRequestDemo
//
//  Created by cocoajin on 14-1-10.
//  Copyright (c) 2014年 www.zhgu.net. All rights reserved.
//

#import "RootTableVC.h"
#import "ASIClient.h"
#import "SVProgressHUD.h"

@interface RootTableVC ()

@end

@implementation RootTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc
{
    [cellDataArray release];
    cellDataArray = nil;
    [resumeBar release];
    resumeBar = nil;
    [super dealloc];
}

- (void)doResume
{
    static BOOL isTap = YES;
    if (isTap) {
        resumeBar.title = @"暂停下载";
        [resumeASIClientRequest cancel];
    }
    else
    {
        resumeBar.title = @"继续下载";
        [self test_ASIClient_RESUME_DOWN_FILE];
    }
    isTap = !isTap;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
    self.title = @"ASIHTTPRequest ";
    
    cellDataArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    [cellDataArray addObject:@"GET 无参数"];
    [cellDataArray addObject:@"GET 有参数"];
    [cellDataArray addObject:@"POST 请求"];
    
    [cellDataArray addObject:@"ASIHTTP 下载文件"];
    [cellDataArray addObject:@"ASIClient 下载文件"];
    [cellDataArray addObject:@"ASIHTTP 文件上传"];
    [cellDataArray addObject:@"ASIClient 文件上传"];
    [cellDataArray addObject:@"ASIClient Data数据上传"];
    [cellDataArray addObject:@"ASIClient 文件上传带参数"];
    [cellDataArray addObject:@"ASIClient 文件下载，断点续传"];
    
    //此按钮测试，只使用于 最后一个测试，文件下载，断点续传功能；
    resumeBar = [[UIBarButtonItem alloc]initWithTitle:@"暂停下载" style:UIBarButtonItemStylePlain target:self action:@selector(doResume)];
    resumeBar.enabled = NO;
    self.navigationItem.rightBarButtonItem = resumeBar;
    
    asiNetQueue = [[ASINetworkQueue alloc]init];
    [asiNetQueue setShowAccurateProgress:YES];
    //[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"ASIClient_ResumeDOWN_PROGRESS"];

}

#pragma mark ASI ASIClient Test

- (void)test_GET_NO_PARAM
{
    [ASIClient GET_Path:@"movie/top250" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@",JSON);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)test_GET_WITH_PARAM
{
    [ASIClient GET_Path:@"movie/top250" params:@{@"count": @"20",@"start":@"5"} completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@",JSON);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)test_POST_REQUEST
{
    [ASIClient POST_Path:@"movie/top250" params:@{@"start": @"30"} completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@",JSON);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)test_ASI_DOWN_FILE
{
    
    // Helper method for interacting with progress indicators to abstract the details of different APIS (NSProgressIndicator and UIProgressView)
    //+ (void)updateProgressIndicator:(id *)indicator withProgress:(unsigned long long)progress ofTotal:(unsigned long long)total;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:kMusic_DOWN]];
    [request setDownloadDestinationPath:@"/Users/user/Desktop/自由自在.mp3"];
    request.showAccurateProgress = YES;
    [request setCompletionBlock:^{
        NSLog(@"complete");
        [SVProgressHUD showSuccessWithStatus:@"下载成功"];
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request error]);
    }];
    


    
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        static float progress = 0;
        progress += (float)size/total;
        [SVProgressHUD showProgress:progress status:@"正在下载"];
        //NSLog(@"%f",progress);
        if (progress==1.0) {
            [SVProgressHUD dismiss];
            progress = 0;
        }
     
    }];
    
    
    [request startAsynchronous];
}

- (void)test_ASIClient_DownFile
{
    [ASIClient DownFile_Path:kMusic_DOWN writeTo:@"/Users/cocoajin/Desktop/" fileName:@"downMusic.mp3" setProgress:^(float progress) {
        [SVProgressHUD showProgress:progress status:@"正在下载"];
    } completed:^{
        [SVProgressHUD showSuccessWithStatus:@"下载成功"];
    } failed:^(NSError *error) {
        NSLog(@"下载失败%@",error);
    }];
}

- (void)test_ASIHTTP_UPFILE
{
    //公司测试服务器 http://192.168.1.193/index.php/Evidence/uploadTest
    NSString *urlStr = @"http://192.168.1.193:82/index.php/Evidence/uploadTest";
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setFile:@"/Users/user/Desktop/zyzz.mp3" forKey:@"Data"];
    
    __block float progress = 0;
    
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        progress += (float )size/total;
        [SVProgressHUD showProgress:progress status:@"正在上传"];
    }];
    
    [request setCompletionBlock:^{
        NSLog(@"upload completed");
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        NSLog(@"%@",[request responseString]);
        progress = 0;
    }];
    
    [request setFailedBlock:^{
        NSLog(@"%@",[request error]);
    }];
    
    
    [request startAsynchronous];
    
}


- (void)test_ASIClient_FILE_UP
{
    NSString *url = @"http://192.168.1.193:82/index.php/Evidence/uploadTest";
    [ASIClient UploadFile_Path:url file:@"/Users/user/Desktop/zyzz.mp3" forKey:@"Data" params:nil SetProgress:^(float progress) {
        [SVProgressHUD showProgress:progress status:@"正在上传"];
    } completed:^(id JSON, NSString *stringData) {
        NSLog(@"文件上传 completed");
        NSLog(@"%@",stringData);
        [SVProgressHUD showSuccessWithStatus:@"文件上传成功"];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)test_ASIClient_DATA_UP
{
    NSString *url = @"http://192.168.1.193:82/index.php/Evidence/uploadTest";
    NSString *fileStr = @"/Users/user/Desktop/zyzz.mp3";
    NSData *theData = [NSData dataWithContentsOfFile:fileStr];
    [ASIClient UploadData_Path:url fileData:theData forKey:@"Data" params:nil SetProgress:^(float progress) {
        [SVProgressHUD showProgress:progress status:@"正在上传"];
    } completed:^(id JSON, NSString *stringData) {
        NSLog(@"文件上传 completed");
        NSLog(@"%@",stringData);
        [SVProgressHUD showSuccessWithStatus:@"文件上传成功"];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)test_ASIClient_UP_FILE_WITH_PARAMS
{
    ///Evidence/fileNonRealTimeAdd
    NSString *url = @"http://192.168.1.193:82/index.php/Evidence/fileNonRealTimeAdd";
    NSString *fileStr = @"/Users/user/Desktop/zyzz.mp3";
    NSDictionary *params = @{@"UserId": @"10010",@"SceneId":@"2",@"Name":@"zyzz.mp3",@"Type":@"0"};
    [ASIClient UploadFile_Path:url file:fileStr forKey:@"file" params:params SetProgress:^(float progress) {
        [SVProgressHUD showProgress:progress status:@"正在上传"];
    } completed:^(id JSON, NSString *stringData) {
        NSLog(@"文件上传 completed");
        NSLog(@"%@",stringData);
        [SVProgressHUD showSuccessWithStatus:@"文件上传成功"];
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)test_ASIClient_RESUME_DOWN_FILE
{
    NSString *resumePath = k360zip;
    NSString *destionPath = @"/Users/user/Desktop";
    NSString *fileName = @"360zip.exe";
    NSString *tempPath = @"/Users/user/Desktop/";
    resumeASIClientRequest = [ASIClient ResumeDown_Path:resumePath writeTo:destionPath tempPath:tempPath fileName:fileName setProgress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:progress status:@"正在下载"];
        });
    } completed:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"下载成功！"];
        });
        NSLog(@"complete");
    } failed:^(NSError *error) {
        NSLog(@"下载失败%@",error);
    }];
    
    //[asiNetQueue addOperation:resumeASIClientRequest];
    //[asiNetQueue go];
    //[resumeASIClientRequest startAsynchronous];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [cellDataArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    return cell ;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            {
                [self test_GET_NO_PARAM];
                break;
            }
        case 1:
            {
                [self test_GET_WITH_PARAM];
                break;
            }
        case 2:
            {
                [self test_POST_REQUEST];
                break;
            }
        case 3:
        {
            [self test_ASI_DOWN_FILE];
            break;
        }
        case 4:
        {
            [self test_ASIClient_DownFile];
            break;
        }
            
        case 5:
        {
            [self test_ASIHTTP_UPFILE];
            break;
        }
        case 6:
        {
            [self test_ASIClient_FILE_UP];
            break;
        }
          
        case 7:
        {
            [self test_ASIClient_DATA_UP];
            break;
        }
        case 8:
        {
            [self test_ASIClient_UP_FILE_WITH_PARAMS];
            break;
        }
        case 9:
        {
            [self test_ASIClient_RESUME_DOWN_FILE];

            resumeBar.enabled = YES;
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 
 //Some Test
 NSString *url1 = @"http://api.douban.com/v2/movie/top250";
 //NSString *url1 = @"http://api.douban.com/v2/movie/search?q=张艺谋";
 url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url1]];
 [request setCompletionBlock:^{
 NSLog(@"%@",[request url]);
 id obj = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
 NSLog(@"%@",obj);
 
 }];
 
 [request setFailedBlock:^{
 NSLog(@"%@",[request error]);
 }];
 
 [request startAsynchronous];
 
 
 NSDictionary *aDic=@{@"google.com": @"google",@"baidu.com":@"baidu",@"qq.com":@"qq"};
 [aDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
 // NSLog(@"key:%@ --> vale:%@",key,obj);
 }];
 
 [aDic enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id key, id obj, BOOL *stop) {
 NSLog(@"key:%@ --> vale:%@",key,obj);
 
 }];
 
 
 
 
 [ASIClient GET_Path:@"movie/top250" completed:^(id JSON, NSString *stringData) {
 NSLog(@"%@",JSON);
 } failed:^(NSError *error) {
 NSLog(@"%@",error);
 }];
 
 
 [ASIClient GET_Path:@"movie/top250" params:@{@"count": @"20",@"start":@"300"} completed:^(id JSON, NSString *stringData) {
 NSLog(@"%@ %@",JSON,stringData);
 } failed:^(NSError *error) {
 NSLog(@"%@",error);
 }];
 
 
 
 [ASIClient POST_Path:@"movie/top250" params:@{@"count": @"100"} completed:^(id JSON, NSString *stringData) {
 NSLog(@"%@",JSON);
 } failed:^(NSError *error) {
 NSLog(@"%@",error);
 }];
 
 */

@end
