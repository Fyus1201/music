//
//  FYNetManager.m
//  music
//
//  Created by 寿煜宇 on 16/5/18.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYNetManager.h"


static AFHTTPSessionManager *manager = nil;

@implementation FYNetManager

/** AFHTTPSessionManager单例 */
+ (AFHTTPSessionManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 设置接受解析的内容类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"text/javascript",@"application/json", nil];
    });
    return manager;
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)params complationHandle:(void (^)(id, NSError *))completed {
    
    //NSLog(@"Request Path: %@, params %@", path, params);
    //NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[self defaultManager] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        completed(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"GET ERROR: %@",error.userInfo);
    }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)params complationHandle:(void (^)(id, NSError *))completed {
    
    return [[self defaultManager] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        completed(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POST ERROR: %@",error.userInfo);
    }];
}

+ (NSString *)percentURLByPath:(NSString *)path params:(NSDictionary *)params{
    NSMutableString *percentPath =[NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    /*  习惯
     for(int i = 0; i < params.allKeys.count; i ++)
     假设for循环循环1000次，params.allKeys实际上调用的[params allKeys], 会调用allKeys1000次。 OC语言特性是runtime，实际上我们调用一个方法，底层操作是有两个列有方法的列表，常用表和总列表。CPU先在常用表中搜索调用的方法指针，如果找不到，再到总列表中搜索。 在总列表中搜索你调用的方法所在的地址，然后调用完毕之后把这个方法名转移到常用方法列表。如果再次执行某个方法就在常用方法列表中搜索调用，效率更高。但是毕竟每次搜索方法都是耗时的，而swift语言则没有运行时，即没有这个搜索过程。 这是swift比oc效率高20%的原因。 为了避免搜索耗时，我们在for循环外部就把调用次数算出来，这样每次for循环只需要去count所在地址读变量值即可。 这样for循环效率更高。
     */
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else{
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    

    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    /*
    if (kIOS7_OR_LATER) {
        //把字符串中的中文转为%号形势
        return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *encodedUrl = [percentPath stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        return encodedUrl;
    }*/
    
    
}

@end
