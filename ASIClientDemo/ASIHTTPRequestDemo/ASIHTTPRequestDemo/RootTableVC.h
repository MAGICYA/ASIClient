//
//  RootTableVC.h
//  ASIHTTPRequestDemo
//
//  Created by cocoajin on 14-1-10.
//  Copyright (c) 2014年 www.zhgu.net. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASIHTTPRequest;
#import "ASINetworkQueue.h"

@interface RootTableVC : UITableViewController

{
    NSMutableArray *cellDataArray;
    UIBarButtonItem *resumeBar;
    ASIHTTPRequest *resumeASIClientRequest;
    ASINetworkQueue *asiNetQueue;
}

#define kMusic_DOWN @"http://music.baidu.com/data/music/file?link=http://zhangmenshiting.baidu.com/data2/music/107086612/10706222072000256.mp3?xcode=293a194a46167ab7c05b2496db3bf085d54bbd6be37a16ce&song_id=107062220"

#define kMusiz_DH @"http://music.baidu.com/data/music/file?link=http://zhangmenshiting.baidu.com/data2/music/57130474/73007331389384061320.mp3?xcode=d0c8ffed21966c544fcfe0f5fe33a1c963b36c39b34dad89&song_id=7300733"

#define k360zip @"http://down.360safe.com/360zip_setup_3.1.0.2031.exe"

@end
