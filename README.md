ASIClient
=========

ASIClient是ASIHTTPRequest的扩展，提供简单易用的GET,POST,文件上传,文件下载等网络请求接口。(Block,JSON)
所返回的接口数据，已经做JSON处理，可直接在回调块中，调用 JSON 取得数据，调用stringData 取得 string数据；


## 使用需知
1. 本项目为 非ARC 环境
2. 本项目依赖 ASIHTTPRequest 框架，[https://github.com/pokeb/asi-http-request](https://github.com/pokeb/asi-http-request) 请先配置
3. 使用前，请先配置 kAPI_BASE_URL 的根 url; 请先在 ASIClient.m 的头部配置，kAPI_BASE_URL 的值；
4. Debuglog 信息 请配置 IS_ENABLE_DEBUG_LOG 开关；

## 可用接口
```objective-c
+ (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed;
```
```objective-c
+ (ASIHTTPRequest *)GET_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed;
```
```objective-c
+ (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed; 
```
```objective-c
+ (ASIHTTPRequest *)DownFile_Path:(NSString *)path writeTo:(NSString *)destination fileName:(NSString *)name setProgress:(KKProgressBlock)progressBlock completed:(ASIBasicBlock)completedBlock failed:(KKFailedBlock )failed; 
```
```objective-c
+ (ASIHTTPRequest *)UploadFile_Path:(NSString *)path file:(NSString *)filePath forKey:(NSString *)fileKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed;
```
```objective-c
+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed;
```
```objective-c
+ (ASIHTTPRequest *)ResumeDown_Path:(NSString *)path writeTo:(NSString *)destinationPath tempPath:(NSString *)tempPath fileName:(NSString *)name setProgress:(KKProgressBlock )progressBlock completed:(ASIBasicBlock )completedBlock failed:(KKFailedBlock )failed;
```
## 如何使用
```objective-c
#pragma mark ASI ASIClient Test

//GET请求，无参数
- (void)test_GET_NO_PARAM
{
    [ASIClient GET_Path:@"movie/top250" completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@",JSON);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//GET请求，有参数
- (void)test_GET_WITH_PARAM
{
    [ASIClient GET_Path:@"movie/top250" params:@{@"count": @"20",@"start":@"5"} completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@",JSON);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//POST请求
- (void)test_POST_REQUEST
{
    [ASIClient POST_Path:@"movie/top250" params:@{@"start": @"30"} completed:^(id JSON, NSString *stringData) {
        NSLog(@"%@",JSON);
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//文件下载
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

//文件上传
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

//Data数据上传
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

//文件上传，有参数
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



```
## 关于下载，断点续传；
调用接口：
```objective-c
/**
 *  文件下载，支持断点续传功能；
 *
 *  @param path            接口路径，不能为空；
 *  @param destinationPath 下载文件要保存的路径，不能为空；
 *  @param tempPath        临时文件保存的路径，不能为空；
 *  @param name            下载保存的文件名，不能为空；
 *  @param progressBlock   下载文件的Progress块，返回 float progress,在此跟踪下载进度；
 *  @param completedBlock  下载完成回调块，无回返值；
 *  @param failed          下载失败回调块，返回 NSError *error;
 *
 *  @return 返回ASIHTTPRequest的指针，可用于 NSOperationQueue操作
 */
+ (ASIHTTPRequest *)ResumeDown_Path:(NSString *)path writeTo:(NSString *)destinationPath tempPath:(NSString *)tempPath fileName:(NSString *)name setProgress:(KKProgressBlock )progressBlock completed:(ASIBasicBlock )completedBlock failed:(KKFailedBlock )failed;
```
demo 测试

```objective-c
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
```


## 反馈
Email ```dev.keke@gmail.com```
[www.cocoajin.org](www.cocoajin.org)




