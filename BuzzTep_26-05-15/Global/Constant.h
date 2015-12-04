#ifndef BUZZtep_Constant_h
#define BUZZtep_Constant_h

#define Documents_Folder    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define Tmp_Folder			[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define Files_Folder		[Documents_Folder stringByAppendingPathComponent:@"files"]
#define Thumbs_Folder		[Documents_Folder stringByAppendingPathComponent:@"thumbs"]
#define BT_CITY_DB_PATH     [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/btcountrydb.sqlite"]

#ifdef DEBUG
#ifndef DLog
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif
#ifndef ALog
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#endif
#else
#define DLog(...)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ApplicationTile             @"BuzzTep"
#define BASEURL @"http://buzztep.com:80/api"

#define MyPersonModelID             @"55665cce04cdbee008428024"
#define PartnerPersonModelID        @"55665cce04cdbee008428022"
#define FriendShipID                @"55665cce04cdbee008428096"

#define kBTNotificationShowMessage              @"kBTNotificationShowMessage"
#define kBTNotificationShowPassPortProfile              @"kBTNotificationShowPassPortProfile"
#define kBTNotificationShowMeetUp              @"kBTNotificationShowMeetUp"
#define kBTNotificationShowCall              @"kBTNotificationShowCall"



#define kBTNotificationGotNewNotificationCount  @"kBTNotificationGotNewNotificationCount"

#define kBTPersonLocalNotificationCount         @"kBTPersonLocalNotificationCount"
#define kBTPersonLocalID         @"kBTPersonLocalID"

#define kBTGetNotificationInterval  10

#define kBTAdventureTitleColor     [UIColor colorWithRed:188/255.0f green:65/255.0f blue:65/255.0f alpha:1.0]

#define kBTMilestoneTitleColor     [UIColor colorWithRed:112/255.0f green:159/255.0f blue:154/255.0f alpha:1.0]
#define kBTEventTitleColor         [UIColor colorWithRed:254/255.0f green:205/255.0f blue:63/255.0f alpha:1.0]

// Define Privacy Setting Strings.
#define kBTPrivacyBuzzPublic            @"buzzPublic"
#define kBTPrivacyBuzzFriendPublic      @"buzzFriendPublic"
#define kBTPrivacyBuzzCloseFriendPublic @"buzzCloseFriendPublic"
#define kBTPrivacyBuzzFamilyPublic      @"buzzFamilyPublic"

#endif
