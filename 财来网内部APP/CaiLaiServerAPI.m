//
//  CaiLaiServerAPI.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/21.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "CaiLaiServerAPI.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CaiLaiServerAPI

+(void)PostRequestWithParams:(NSDictionary *)params success:(HttpSuccessBlock)success  failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CailaiAPIBaseURLString]];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 60.0;
    //设置response的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript", @"text/html", nil];


    
    //根据需求 加密数据重组字典
    NSDictionary *receivedParameters = [self getPostDictionary:params];
    
    NSURLSessionDataTask *task = [manager POST:@"" parameters:receivedParameters  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"POST请求成功:%@",responseObject);
        
        NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
        NSString *msg = [responseObject valueForKey:@"msg"];
        id data = [responseObject objectForKey:@"data"];        
        if (code != 0) {
            NSError *theError = [[NSError alloc] initWithDomain:msg code:(int)code userInfo:nil];
            failure(theError);
        } else if ([data isEqual:[NSNull null]]) {
            NSError *theError = [[NSError alloc] initWithDomain:@"data 为空" code:-1 userInfo:nil];
            failure(theError);
        } else {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"%@",error);
    }];
    
}



+ (NSDictionary *)getPostDictionary: (NSDictionary *)param {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:param];
    // 第一步：组成请求内容的数组
    [dict setValue:@"ios" forKey:@"pname"];
    // 第二步: 生成请求内容的json字符串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    // 第三步：连接第二步产生的json字符串与校验码
    NSString *preToken = [NSString stringWithFormat:@"%@%@", content, SecretKey];
    // 第四步：通过md5生成签名的token值
    NSString *token = [self md5:preToken];
    // 第五步：生成 post 数据
    NSDictionary *postDic = [[NSDictionary alloc] initWithObjectsAndKeys:content, @"content", token, @"token", nil];
    //    [postDic setValue:content forKey:@"content"];
    //    [postDic setValue:token forKey:@"token"];
    return postDic;
}

+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}



+(void)GetRequestWithUrlString:(NSString *)urlString success:(HttpSuccessBlock)success  failure:(HttpFailureBlock)failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CailaiAPIBaseURLString]];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 60.0;
    //设置response的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (!error) {
            NSLog(@"File downloaded to: %@", filePath);
            success(filePath);
        }
        else{
            failure(error);
        }
    }];
  
    
    [downloadTask resume];
   
        
    
   
    
}


@end
