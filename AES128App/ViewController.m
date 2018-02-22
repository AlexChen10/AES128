//
//  ViewController.m
//  AES128App
//
//  Created by 陈玉 on 16/4/23.
//  Copyright © 2016年 陈玉. All rights reserved.
//

#import "ViewController.h"
#import "AesInterns.h"
#import "AesInterns.h"
#import "EfAes.h"

@interface ViewController ()
{
    BYTE  result[16];

}
@end

@implementation ViewController
{

    UITextField *encryptTextField;
    UILabel *afterEncryptLabel;
}

#define KEY_LEN ((u8)16) //密钥长度
#define HARDWARE_ID_LEN ((u8)12)//cpu ID长度
#define _NULL ((void*)0)

#define RANDOM_LEN ((u8)8)
#define SUCCESS 0
#define FAILED 1

void PtrInitAes(BYTE* key,u8 len);
BYTE Encrypt(BYTE* input,BYTE* output);

static BYTE b_IsInitionlizedAes = 0;

BYTE  g_key[KEY_LEN];

AesCtx  g_aes_ctx;

BlockMode g_aes_mode=BLOCKMODE_ECB;

//BYTE  ABCD[4]="ABCD";

void PtrInitAes(BYTE* key,u8 len){
    //BYTE code[KEY_LEN]={0};
    memcpy(g_key,key,len);
    AesSetKey(&g_aes_ctx,AES_KEY_128BIT,g_aes_mode,g_key,_NULL);
    b_IsInitionlizedAes=SUCCESS;
}

//加密函数
BYTE Encrypt(BYTE* input,BYTE* output){
    BYTE code[KEY_LEN]={0};
    if(b_IsInitionlizedAes!=SUCCESS){
        return FAILED;
    }
    
    memcpy(code,input,RANDOM_LEN);
    AesEncryptECB(&g_aes_ctx,output,code,KEY_LEN);
    return SUCCESS;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubViews];
}

- (void)setUpSubViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    encryptTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 160, 180, 40)];
    encryptTextField.placeholder = @"输入要加密的字段";
    encryptTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    encryptTextField.borderStyle = UITextBorderStyleRoundedRect;
    encryptTextField.layer.borderColor = [UIColor grayColor].CGColor;
    encryptTextField.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:encryptTextField];
    
    UIButton *encryptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    encryptBtn.frame = CGRectMake(270, 160, 70, 40);
    [encryptBtn setTitle:@"加密" forState:UIControlStateNormal];
    [encryptBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    encryptBtn.layer.cornerRadius = 3;
    encryptBtn.layer.masksToBounds = YES;
    encryptBtn.layer.borderColor = [UIColor grayColor].CGColor;
    encryptBtn.layer.borderWidth = 1;
    [encryptBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [encryptBtn addTarget:self action:@selector(onEncryptBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:encryptBtn];
    
    afterEncryptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, self.view.frame.size.width-2*20, 40)];
    afterEncryptLabel.textColor = [UIColor grayColor];
    afterEncryptLabel.textAlignment = NSTextAlignmentCenter;
    afterEncryptLabel.text = @"加密后结果";
    afterEncryptLabel.font = [UIFont systemFontOfSize:15];
    afterEncryptLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    afterEncryptLabel.layer.borderWidth = 0.4;
    afterEncryptLabel.layer.cornerRadius = 3;
    afterEncryptLabel.layer.masksToBounds = YES;
    [self.view addSubview:afterEncryptLabel];
}

- (void)onEncryptBtnClick {

    BYTE  key1[16]={0};
    
    PtrInitAes(key1,16);
    
    NSData *data = [encryptTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[data bytes];
    
    Encrypt(bytes,result);
    
    afterEncryptLabel.text = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0],result[1],result[2],result[3],result[4],result[5],result[6],result[7],result[8],result[9],result[10],result[11],result[12],result[13],result[14],result[15]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
