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
        MainViewController(storyboardName: "Main3", imageName: "three")
        //MainViewController(storyboardName: "Main4", imageName: "four")
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

let kEmployeeAccounts = ["400680", "403902", "1225726", "4806789", "6409809", "12800553", "121800083", "500011038", "558159381", "723748661"]

let kUserDefaultsActivityFeedViewControllerLastRefreshKey = "com.parse.Anypic.userDefaults.activityFeedViewController.lastRefresh"
let kUserDefaultsCacheFacebookFriendsKey = "com.parse.Anypic.userDefaults.cache.facebookFriends"

// MARK:- Launch URLs

let kLaunchURLHostTakePicture = "camera"

// MARK:- NSNotification

let AppDelegateApplicationDidReceiveRemoteNotification           = "com.parse.Anypic.appDelegate.applicationDidReceiveRemoteNotification"
let UtilityUserFollowingChangedNotification                      = "com.parse.Anypic.utility.userFollowingChanged"
let UtilityUserLikedUnlikedPhotoCallbackFinishedNotification     = "com.parse.Anypic.utility.userLikedUnlikedPhotoCallbackFinished"
let UtilityDidFinishProcessingProfilePictureNotification         = "com.parse.Anypic.utility.didFinishProcessingProfilePictureNotification"
let TabBarControllerDidFinishEditingPhotoNotification            = "com.parse.Anypic.tabBarController.didFinishEditingPhoto"
let TabBarControllerDidFinishImageFileUploadNotification         = "com.parse.Anypic.tabBarController.didFinishImageFileUploadNotification"
let PhotoDetailsViewControllerUserDeletedPhotoNotification       = "com.parse.Anypic.photoDetailsViewController.userDeletedPhoto"
let PhotoDetailsViewControllerUserLikedUnlikedPhotoNotification  = "com.parse.Anypic.photoDetailsViewController.userLikedUnlikedPhotoInDetailsViewNotification"
let PhotoDetailsViewControllerUserCommentedOnPhotoNotification   = "com.parse.Anypic.photoDetailsViewController.userCommentedOnPhotoInDetailsViewNotification"

// MARK:- User Info Keys
let PhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey = "liked"
let kEditPhotoViewControllerUserInfoCommentKey = "comment"

// MARK:- Installation Class

// Field keys
let kInstallationUserKey = "user"

// MARK:- Activity Class
// Class key
let kActivityClassKey = "Activity"

// Field keys
let kActivityTypeKey        = "type"
let kActivityFromUserKey    = "fromUser"
let kActivityToUserKey      = "toUser"
let kActivityContentKey     = "content"
let kActivityPhotoKey       = "photo"

// Type values
let kActivityTypeLike       = "like"
let kActivityTypeFollow     = "follow"
let kActivityTypeComment    = "comment"
let kActivityTypeJoined     = "joined"

// MARK:- User Class
// Field keys
let kUserDisplayNameKey                          = "displayName"
let kUserFacebookIDKey                           = "facebookId"
let kUserPhotoIDKey                              = "photoId"
let kUserProfilePicSmallKey                      = "profilePictureSmall"
let kUserProfilePicMediumKey                     = "profilePictureMedium"
let kUserFacebookFriendsKey                      = "facebookFriends"
let kUserAlreadyAutoFollowedFacebookFriendsKey   = "userAlreadyAutoFollowedFacebookFriends"
let kUserEmailKey                                = "email"
let kUserAutoFollowKey                           = "autoFollow"

// MARK:- Photo Class

// Class key
let kPhotoClassKey = "Photo"

// Field keys
let kPhotoPictureKey         = "image"
let kPhotoThumbnailKey       = "thumbnail"
let kPhotoUserKey            = "user"
let kPhotoOpenGraphIDKey     = "fbOpenGraphID"
let kPrayerUserKey           = "prayer"

// MARK:- Cached Photo Attributes
// keys
let kPhotoAttributesIsLikedByCurrentUserKey = "isLikedByCurrentUser";
let kPhotoAttributesLikeCountKey            = "likeCount"
let kPhotoAttributesLikersKey               = "likers"
let kPhotoAttributesCommentCountKey         = "commentCount"
let kPhotoAttributesCommentersKey           = "commenters"

// MARK:- Cached User Attributes
// keys
let kUserAttributesPhotoCountKey                 = "photoCount"
let kUserAttributesIsFollowedByCurrentUserKey    = "isFollowedByCurrentUser"

// MARK:- Push Notification Payload Keys

let kAPNSAlertKey = "alert"
let kAPNSBadgeKey = "badge"
let kAPNSSoundKey = "sound"

// the following keys are intentionally kept short, APNS has a maximum payload limit
let kPushPayloadPayloadTypeKey          = "p"
let kPushPayloadPayloadTypeActivityKey  = "a"

let kPushPayloadActivityTypeKey     = "t"
let kPushPayloadActivityLikeKey     = "l"
let kPushPayloadActivityCommentKey  = "c"
let kPushPayloadActivityFollowKey   = "f"

let kPushPayloadFromUserObjectIdKey = "fu"
let kPushPayloadToUserObjectIdKey   = "tu"
let kPushPayloadPhotoObjectIdKey = "pid"
