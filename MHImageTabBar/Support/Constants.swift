//
//  Constants.swift
//  MHImageTabBar
//
//  Created by teklabsco on 12/15/15.
//  Copyright © 2015 MHO. All rights reserved.
//

import Foundation
import UIKit

struct MHImageTabBarConstants {
    
    static let mainViewControllers = [
        MainViewController(storyboardName: "Main1", imageName: "one"),
        MainViewController(storyboardName: "Main2", imageName: "two"),
        MainViewController(storyboardName: "Main3", imageName: "three"),
        MainViewController(storyboardName: "Main4", imageName: "four")
    ]
    
    static let RTL = false
    
    static let tabBarAnimationDuration = NSTimeInterval(0.2)
}
enum TabBarControllerViewControllerIndex: Int {
    case HomeTabBarItemIndex = 0, EmptyTabBarItemIndex, ActivityTabBarItemIndex
}

// Ilya     400680
// James    403902
// David    1225726
// Bryan    4806789
// Thomas   6409809
// Ashley   12800553
// Héctor   121800083
// Kevin    500011038
// Chris    558159381
// Matt     723748661

let kPAPParseEmployeeAccounts = ["400680", "403902", "1225726", "4806789", "6409809", "12800553", "121800083", "500011038", "558159381", "723748661"]

let kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey = "com.parse.Anypic.userDefaults.activityFeedViewController.lastRefresh"
let kPAPUserDefaultsCacheFacebookFriendsKey = "com.parse.Anypic.userDefaults.cache.facebookFriends"

// MARK:- Launch URLs

let kPAPLaunchURLHostTakePicture = "camera"

// MARK:- NSNotification

let PAPAppDelegateApplicationDidReceiveRemoteNotification           = "com.parse.Anypic.appDelegate.applicationDidReceiveRemoteNotification"
let UtilityUserFollowingChangedNotification                      = "com.parse.Anypic.utility.userFollowingChanged"
let UtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = "com.parse.Anypic.utility.userLikedUnlikedPhotoCallbackFinished"
let UtilityDidFinishProcessingProfilePictureNotification         = "com.parse.Anypic.utility.didFinishProcessingProfilePictureNotification"
let TabBarControllerDidFinishEditingPhotoNotification            = "com.parse.Anypic.tabBarController.didFinishEditingPhoto"
let PAPTabBarControllerDidFinishImageFileUploadNotification         = "com.parse.Anypic.tabBarController.didFinishImageFileUploadNotification"
let PAPPhotoDetailsViewControllerUserDeletedPhotoNotification       = "com.parse.Anypic.photoDetailsViewController.userDeletedPhoto"
let PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = "com.parse.Anypic.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification"
let PAPPhotoDetailsViewControllerUserCommentedOnPhotoNotification   = "com.parse.Anypic.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification"

// MARK:- User Info Keys
let PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = "liked"
let kPAPEditPhotoViewControllerUserInfoCommentKey = "comment"

// MARK:- Installation Class

// Field keys
let kPAPInstallationUserKey = "user"

// MARK:- Activity Class
// Class key
let kPAPActivityClassKey = "Activity"

// Field keys
let kPAPActivityTypeKey        = "type"
let kPAPActivityFromUserKey    = "fromUser"
let kPAPActivityToUserKey      = "toUser"
let kPAPActivityContentKey     = "content"
let kPAPActivityPhotoKey       = "photo"

// Type values
let kPAPActivityTypeLike       = "like"
let kPAPActivityTypeFollow     = "follow"
let kPAPActivityTypeComment    = "comment"
let kPAPActivityTypeJoined     = "joined"

// MARK:- User Class
// Field keys
let kPAPUserDisplayNameKey                          = "displayName"
let kPAPUserFacebookIDKey                           = "facebookId"
let kPAPUserPhotoIDKey                              = "photoId"
let kPAPUserProfilePicSmallKey                      = "profilePictureSmall"
let kPAPUserProfilePicMediumKey                     = "profilePictureMedium"
let kPAPUserFacebookFriendsKey                      = "facebookFriends"
let kPAPUserAlreadyAutoFollowedFacebookFriendsKey   = "userAlreadyAutoFollowedFacebookFriends"
let kPAPUserEmailKey                                = "email"
let kPAPUserAutoFollowKey                           = "autoFollow"

// MARK:- Photo Class

// Class key
let kPAPPhotoClassKey = "Photo"

// Field keys
let kPAPPhotoPictureKey         = "image"
let kPAPPhotoThumbnailKey       = "thumbnail"
let kPAPPhotoUserKey            = "user"
let kPAPPhotoOpenGraphIDKey     = "fbOpenGraphID"
let kPAPPrayerUserKey           = "prayer"

// MARK:- Cached Photo Attributes
// keys
let kPAPPhotoAttributesIsLikedByCurrentUserKey = "isLikedByCurrentUser";
let kPAPPhotoAttributesLikeCountKey            = "likeCount"
let kPAPPhotoAttributesLikersKey               = "likers"
let kPAPPhotoAttributesCommentCountKey         = "commentCount"
let kPAPPhotoAttributesCommentersKey           = "commenters"

// MARK:- Cached User Attributes
// keys
let kPAPUserAttributesPhotoCountKey                 = "photoCount"
let kPAPUserAttributesIsFollowedByCurrentUserKey    = "isFollowedByCurrentUser"

// MARK:- Push Notification Payload Keys

let kAPNSAlertKey = "alert"
let kAPNSBadgeKey = "badge"
let kAPNSSoundKey = "sound"

// the following keys are intentionally kept short, APNS has a maximum payload limit
let kPAPPushPayloadPayloadTypeKey          = "p"
let kPAPPushPayloadPayloadTypeActivityKey  = "a"

let kPAPPushPayloadActivityTypeKey     = "t"
let kPAPPushPayloadActivityLikeKey     = "l"
let kPAPPushPayloadActivityCommentKey  = "c"
let kPAPPushPayloadActivityFollowKey   = "f"

let kPAPPushPayloadFromUserObjectIdKey = "fu"
let kPAPPushPayloadToUserObjectIdKey   = "tu"
let kPAPPushPayloadPhotoObjectIdKey = "pid"
