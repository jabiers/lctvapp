//
//  AppDefines.h
//  lctv
//
//  Created by Kim DaeHyun on 2015. 9. 19..
//  Copyright (c) 2015년 Kim DaeHyun. All rights reserved.
//

#ifndef lctv_AppDefines_h
#define lctv_AppDefines_h

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define HOST_URL_STRING @"https://livecoding.tv"
#define HOST_URL [NSURL URLWithString:HOST_URL_STRING]
#define HOME_URL_REQUEST [CommonUtils requestFromString:HOST_URL_STRING]

#define CAN_GET_HEADER_INFO @[@"https://www.livecoding.tv/livestreams/", @"https://www.livecoding.tv/videos/", @"https://www.livecoding.tv/playlists/", @"https://www.livecoding.tv/accounts/login/"]
#endif
