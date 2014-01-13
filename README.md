ASIClient
=========

ASIClient是ASIHTTPRequest的扩展，提供简单易用的GET,POST,文件上传,文件下载等网络请求接口。(Block,JSON)


# 使用需知
1.本项目为 非ARC 环境
2.本项目依赖 ASIHTTPRequest 框架，[https://github.com/pokeb/asi-http-request](https://github.com/pokeb/asi-http-request) 请先配置
3.使用前，请先配置 kAPI_BASE_URL 的根 url; 请先在 ASIClient.m 的头部配置，kAPI_BASE_URL 的值；
4.Debuglog 信息 请配置 IS_ENABLE_DEBUG_LOG 开关；

# 可用接口
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
```+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed;
```
```objective-c
+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed;
```
```objective-c
+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed;
```

# 如何使用




