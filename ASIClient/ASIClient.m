//
//  ASIClient.m
//  ASIHTTPRequestDemo
//
//  Created by cocoajin on 14-1-10.
//  Copyright (c) 2014年 www.cocoajin.org All rights reserved.
//

#import "ASIClient.h"

NSString *const kAPI_BASE_URL = @"";

//示例，为豆瓣api 
//NSString *const kAPI_BASE_URL = @"http://api.douban.com/v2/";


@implementation ASIClient


+ (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    [self throwExctionWith_NO_BASE_URL];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient GET: %@",[request url]);
    
    return request;
}


+ (ASIHTTPRequest *)GET_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    [self throwExctionWith_NO_BASE_URL];
    NSMutableString *paramsString = [NSMutableString stringWithCapacity:1];
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramsString appendFormat:@"%@=%@",key,obj];
        [paramsString appendString:@"&"];
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",kAPI_BASE_URL,path,paramsString];
    urlStr = [urlStr substringToIndex:urlStr.length-1];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.requestMethod = @"GET";
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient GET: %@",[request url]);
    
    
    
    return request;
}


+ (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.requestMethod = @"POST";
    
    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setPostValue:obj forKey:key];
    }];
    
    [request setCompletionBlock:^{
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completeBlock(jsonData,request.responseString);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient POST: %@ %@",[request url],paramsDic);
    
    
    
    return request;

}


+ (ASIHTTPRequest *)DownFile_Path:(NSString *)path writeTo:(NSString *)destination fileName:(NSString *)name setProgress:(KKProgressBlock)progressBlock completed:(ASIBasicBlock)completedBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString *filePath = nil;
    if ([destination hasSuffix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@",destination,name];  
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@",destination,name];
    }
    [request setDownloadDestinationPath:filePath];
    
    __block float downProgress = 0;
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        downProgress += (float)size/total;
        progressBlock(downProgress);
    }];
    
    [request setCompletionBlock:^{
        downProgress = 0;
        completedBlock();
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient 下载文件：%@ ",urlStr);
    kNSLog(@"ASIClient 保存路径：%@",filePath);
    
    
    return request;
}


+ (ASIHTTPRequest *)UploadFile_Path:(NSString *)path file:(NSString *)filePath forKey:(NSString *)fileKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setFile:filePath forKey:fileKey];
    if (params.count > 0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    __block float upProgress = 0;
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        upProgress += (float)size/total;
        progressBlock(upProgress);
    }];
    
    [request setCompletionBlock:^{
        upProgress=0;
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completedBlock(jsonData,[request responseString]);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient 文件上传：%@ file=%@ key=%@",urlStr,filePath,fileKey);
    kNSLog(@"ASIClient 文件上传参数：%@",params);
    
    
    
    return request;
}


+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setData:fData forKey:dataKey];
    if (params.count > 0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    __block float upProgress = 0;
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        upProgress += (float)size/total;
        progressBlock(upProgress);
    }];
    
    [request setCompletionBlock:^{
        upProgress=0;
        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
        completedBlock(jsonData,[request responseString]);
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient 文件上传：%@ size=%.2f MB  key=%@",urlStr,fData.length/1024.0/1024.0,dataKey);
    kNSLog(@"ASIClient 文件上传参数：%@",params);
    
    return request;

}


+ (ASIHTTPRequest *)ResumeDown_Path:(NSString *)path writeTo:(NSString *)destinationPath tempPath:(NSString *)tempPath fileName:(NSString *)name setProgress:(KKProgressBlock )progressBlock completed:(ASIBasicBlock )completedBlock failed:(KKFailedBlock )failed
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString *filePath = nil;
    if ([destinationPath hasSuffix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@",destinationPath,name];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@",destinationPath,name];
    }
    
    [request setDownloadDestinationPath:filePath];
    
    NSString *tempForDownPath = nil;
    if ([tempPath hasSuffix:@"/"]) {
        tempForDownPath = [NSString stringWithFormat:@"%@%@.download",tempPath,name];
    }
    else
    {
        tempForDownPath = [NSString stringWithFormat:@"%@/%@.download",tempPath,name];
    }
    
    [request setTemporaryFileDownloadPath:tempForDownPath];
    [request setAllowResumeForFileDownloads:YES];
    
    __block float downProgress = 0;
    downProgress = [[NSUserDefaults standardUserDefaults] floatForKey:@"ASIClient_ResumeDOWN_PROGRESS"];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        downProgress += (float)size/total;
        if (downProgress >1.0) {
            downProgress=1.0;
        }
        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"ASIClient_ResumeDOWN_PROGRESS"];
        progressBlock(downProgress);
    }];
    
    [request setCompletionBlock:^{
        downProgress = 0;
        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"ASIClient_ResumeDOWN_PROGRESS"];
        completedBlock();
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempForDownPath]) {
            //NSError *errorForDelete = [NSError errorWithDomain:@"删除临时文件发生错误！" code:2015 userInfo:@{@"删除临时文件发生错误": @"中文",@"delete the temp fife error":@"English"}];
            //[[NSFileManager defaultManager] removeItemAtPath:tempForDownPath error:&errorForDelete];
            kNSLog(@"l  %d> %s",__LINE__,__func__);
        }
    }];
    
    [request setFailedBlock:^{
        failed([request error]);
    }];
    
    [request startAsynchronous];
    
    kNSLog(@"ASIClient 下载文件：%@ ",urlStr);
    kNSLog(@"ASIClient 保存路径：%@",filePath);
    if (downProgress >0 && downProgress) {
        if (downProgress >=1.0) downProgress = 0.9999;
        kNSLog(@"ASIClient 上次下载已完成：%.2f/100",downProgress*100);
    }
    
    
    return request;

}

//kAPI_BASE_URL 如果 base url 没有赋值 的异常处理
+ (void)throwExctionWith_NO_BASE_URL
{
    @try {
        if (kAPI_BASE_URL.length <=0 ) {
            NSDictionary *userInfo = @{@"Result": @"请在ASIClient.m 头部，配置 kAPI_BASE_URL 的值"};
            @throw [NSException exceptionWithName:@"ASIClient配置异常" reason:@"kAPI_BASE_URL 没有配置初始化的根 URL 错误；" userInfo:userInfo];
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alertException = [[UIAlertView alloc]initWithTitle:exception.name message:[NSString stringWithFormat:@"%@%@",exception.reason,@"请在ASIClient.m 头部，配置 kAPI_BASE_URL 的值"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alertException show];
        [alertException release];
    }
    @finally {
        //assert(kAPI_BASE_URL);
    }
}




//废弃的方法；
- (void)GET:(NSString *)path params:(NSDictionary *)params ompletionBlock:(ASIBasicBlock )completedBlock failedBlock:(ASIBasicBlock )failBlock;
{

    
    NSURL *url = [NSURL URLWithString:path];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:completedBlock];
    [request setFailedBlock:failBlock];
    [request startAsynchronous];
}




@end
