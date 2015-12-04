#import <UIKit/UIKit.h>

#import "AppDelegate.h"

typedef enum {
    Notification_Type_None,
    Notification_Type_Adventure,
    Notification_Type_Milestone,
    Notification_Type_Meetup,
    Notification_Type_Media,
    Notification_Type_Event,
    Notification_Type_Message
} NotificationTYPE;

typedef enum {
    Privacy_Relation_None,
    Privacy_Relation_Friend,
    Privacy_Relation_CloseFriend,
    Privacy_Relation_Family,
    Privacy_Relation_Public
} PrivacyRelationTYPE;

typedef enum {
    Global_BuzzType_Adventure,
    Global_BuzzType_Milestone,
    Global_BuzzType_Event
} GlobalBuzzType;


