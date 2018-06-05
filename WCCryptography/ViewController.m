//
//  ViewController.m
//  WCCryptography
//
//  Created by admin on 05/06/2018.
//  Copyright © 2018 guanweicheng. All rights reserved.
//

#import "ViewController.h"
#import "EncryptionTools.h"
#import "RSACryptor.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testSymCryptography];
    NSLog(@"-------------------");
    [self testAsyCryptography];
}

#pragma mark --- 非对称加密
- (void)testAsyCryptography {
    //1.加载公钥
    [[RSACryptor sharedRSACryptor] loadPublicKey:[[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil]];
    //2. 加载私钥 - P12的文件  password : 生成P12 的时候设置的密码
    [[RSACryptor sharedRSACryptor] loadPrivateKey:[[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil] password:@"123456"];
    sleep(2);
    NSData * reault = [[RSACryptor sharedRSACryptor] encryptData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    //base64 编码
    NSString * base64 = [reault base64EncodedStringWithOptions:0];
    NSLog(@"RSA加密的信息: %@",base64);
    //解密
    NSData * jiemi = [[RSACryptor sharedRSACryptor] decryptData:reault];
    NSLog(@"RSA解密的信息%@",[[NSString alloc]initWithData:jiemi encoding:NSUTF8StringEncoding]);
}

#pragma mark --- 对称加密
- (void)testSymCryptography {
    //AES - ECB 加密
    NSString * key = @"wc";
    //加密
    NSLog(@"AES - ECB加密: %@",[[EncryptionTools sharedEncryptionTools] encryptString:@"hello" keyString:key iv:nil]);
    //解密
    NSLog(@"AES - ECB解密: %@",[[EncryptionTools sharedEncryptionTools] decryptString:@"p7kPyb+MFPfE0qtDJnViSA==" keyString:key iv:nil]);
    
     //AES - CBC 加密
     uint8_t iv[8] = {2,3,4,5,6,7,0,0}; //直接影响加密结果!
     NSData * ivData = [NSData dataWithBytes:iv length:sizeof(iv)];
     
     NSLog(@"AES - CBC加密: %@",[[EncryptionTools sharedEncryptionTools] encryptString:@"hello" keyString:key iv:ivData]);
     
     NSLog(@"AES - CBC解密: %@", [[EncryptionTools sharedEncryptionTools] decryptString:@"Yp5cvOaHOr38Q6tnpyGtlA==" keyString:key iv:ivData]);
     
     //DES - ECB 加密
     [EncryptionTools sharedEncryptionTools].algorithm = kCCAlgorithmDES;
     NSLog(@"DES - ECB加密%@",[[EncryptionTools sharedEncryptionTools] encryptString:@"hello" keyString:key iv:nil]);
     NSLog(@"DES - ECB解密: %@", [[EncryptionTools sharedEncryptionTools] decryptString:@"7i8rIvL8FEo=" keyString:key iv:nil]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
