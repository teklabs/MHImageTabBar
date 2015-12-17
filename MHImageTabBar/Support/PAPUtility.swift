import Foundation
import CoreGraphics
import UIImageAFAdditions
import ParseFacebookUtils

class PAPUtility {

    // MARK:- Utility
    
    // MARK Like Photos

    class func likePhotoInBackground(photo: PFObject, block completionBlock: ((succeeded: Bool, error: NSError?) -> Void)?) {
        let queryExistingLikes = PFQuery(className: kActivityClassKey)
        queryExistingLikes.whereKey(kActivityPhotoKey, equalTo: photo)
        queryExistingLikes.whereKey(kActivityTypeKey, equalTo: kActivityTypeLike)
        queryExistingLikes.whereKey(kActivityFromUserKey, equalTo: PFUser.currentUser()!)
        queryExistingLikes.cachePolicy = PFCachePolicy.NetworkOnly
        queryExistingLikes.findObjectsInBackgroundWithBlock { (activities, error) in
            if error == nil {
                for activity in activities as! [PFObject] {
// FIXME: To be removed! this is synchronous!                    activity.delete()
                    activity.deleteInBackground()
                }
            }
            
            // proceed to creating new like
            let likeActivity = PFObject(className: kActivityClassKey)
            likeActivity.setObject(kActivityTypeLike, forKey: kActivityTypeKey)
            likeActivity.setObject(PFUser.currentUser()!, forKey: kActivityFromUserKey)
            likeActivity.setObject(photo.objectForKey(kPhotoUserKey)!, forKey: kActivityToUserKey)
            likeActivity.setObject(photo, forKey: kActivityPhotoKey)
            
            let likeACL = PFACL(user: PFUser.currentUser()!)
            likeACL.setPublicReadAccess(true)
            likeACL.setWriteAccess(true, forUser: photo.objectForKey(kPhotoUserKey) as! PFUser)
            likeActivity.ACL = likeACL

            likeActivity.saveInBackgroundWithBlock { (succeeded, error) in
                if completionBlock != nil {
                    completionBlock!(succeeded: succeeded.boolValue, error: error)
                }

                // refresh cache
                let query = Utility.queryForActivitiesOnPhoto(photo, cachePolicy: PFCachePolicy.NetworkOnly)
                query.findObjectsInBackgroundWithBlock { (objects, error) in
                    if error == nil {
                        var likers = [PFUser]()
                        var commenters = [PFUser]()
                        
                        var isLikedByCurrentUser = false
                        
                        for activity in objects as! [PFObject] {
                            if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeLike && activity.objectForKey(kActivityFromUserKey) != nil {
                                likers.append(activity.objectForKey(kActivityFromUserKey) as! PFUser)
                            } else if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeComment && activity.objectForKey(kActivityFromUserKey) != nil {
                                commenters.append(activity.objectForKey(kActivityFromUserKey) as! PFUser)
                            }
                            
                            if (activity.objectForKey(kActivityFromUserKey) as? PFUser)?.objectId == PFUser.currentUser()!.objectId {
                                if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeLike {
                                    isLikedByCurrentUser = true
                                }
                            }
                        }
                        
                        Cache.sharedCache.setAttributesForPhoto(photo, likers: likers, commenters: commenters, likedByCurrentUser: isLikedByCurrentUser)
                    }

                    NSNotificationCenter.defaultCenter().postNotificationName(UtilityUserLikedUnlikedPhotoCallbackFinishedNotification, object: photo, userInfo: [PhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey: succeeded.boolValue])
                }

            }
        }
    }

    class func unlikePhotoInBackground(photo: PFObject, block completionBlock: ((succeeded: Bool, error: NSError?) -> Void)?) {
        let queryExistingLikes = PFQuery(className: kActivityClassKey)
        queryExistingLikes.whereKey(kActivityPhotoKey, equalTo: photo)
        queryExistingLikes.whereKey(kActivityTypeKey, equalTo: kActivityTypeLike)
        queryExistingLikes.whereKey(kActivityFromUserKey, equalTo: PFUser.currentUser()!)
        queryExistingLikes.cachePolicy = PFCachePolicy.NetworkOnly
        queryExistingLikes.findObjectsInBackgroundWithBlock { (activities, error) in
            if error == nil {
                for activity in activities as! [PFObject] {
// FIXME: To be removed! this is synchronous!                    activity.delete()
                    activity.deleteInBackground()
                }
                
                if completionBlock != nil {
                    completionBlock!(succeeded: true, error: nil)
                }

                // refresh cache
                let query = Utility.queryForActivitiesOnPhoto(photo, cachePolicy: PFCachePolicy.NetworkOnly)
                query.findObjectsInBackgroundWithBlock { (objects, error) in
                    if error == nil {
                        
                        var likers = [PFUser]()
                        var commenters = [PFUser]()
                        
                        var isLikedByCurrentUser = false
                        
                        for activity in objects as! [PFObject] {
                            if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeLike {
                                likers.append(activity.objectForKey(kActivityFromUserKey) as! PFUser)
                            } else if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeComment {
                                commenters.append(activity.objectForKey(kActivityFromUserKey) as! PFUser)
                            }
                            
                            if (activity.objectForKey(kActivityFromUserKey) as! PFUser).objectId == PFUser.currentUser()!.objectId {
                                if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeLike {
                                    isLikedByCurrentUser = true
                                }
                            }
                        }
                        
                        Cache.sharedCache.setAttributesForPhoto(photo, likers: likers, commenters: commenters, likedByCurrentUser: isLikedByCurrentUser)
                    }
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(UtilityUserLikedUnlikedPhotoCallbackFinishedNotification, object: photo, userInfo: [PhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey: false])
                }

            } else {
                if completionBlock != nil {
                    completionBlock!(succeeded: false, error: error)
                }
            }
        }
    }

    // MARK Facebook

    class func processFacebookProfilePictureData(newProfilePictureData: NSData) {
        print("Processing profile picture of size: \(newProfilePictureData.length)")
        if newProfilePictureData.length == 0 {
            return
        }
        
        let image = UIImage(data: newProfilePictureData)
        
        let mediumImage: UIImage = image!.thumbnailImage(280, transparentBorder: 0, cornerRadius: 0, interpolationQuality: CGInterpolationQuality.High)
        let smallRoundedImage: UIImage = image!.thumbnailImage(64, transparentBorder: 0, cornerRadius: 0, interpolationQuality: CGInterpolationQuality.Low)

        let mediumImageData: NSData = UIImageJPEGRepresentation(mediumImage, 0.5)! // using JPEG for larger pictures
        let smallRoundedImageData: NSData = UIImagePNGRepresentation(smallRoundedImage)!

        if mediumImageData.length > 0 {
            let fileMediumImage: PFFile = PFFile(data: mediumImageData)
            fileMediumImage.saveInBackgroundWithBlock { (succeeded, error) in
                if error == nil {
                    PFUser.currentUser()!.setObject(fileMediumImage, forKey: kUserProfilePicMediumKey)
                    PFUser.currentUser()!.saveInBackground()
                }
            }
        }
        
        if smallRoundedImageData.length > 0 {
            let fileSmallRoundedImage: PFFile = PFFile(data: smallRoundedImageData)
            fileSmallRoundedImage.saveInBackgroundWithBlock { (succeeded, error) in
                if error == nil {
                    PFUser.currentUser()!.setObject(fileSmallRoundedImage, forKey: kUserProfilePicSmallKey)
                    PFUser.currentUser()!.saveInBackground()
                }
            }
        }
        print("Processed profile picture")
    }

    class func userHasValidFacebookData(user: PFUser) -> Bool {
        // Check that PFUser has valid fbid that matches current FBSessions userId
        let facebookId = user.objectForKey(kUserFacebookIDKey) as? String
        return (facebookId != nil && facebookId!.characters.count > 0 && facebookId == PFFacebookUtils.session()!.accessTokenData.userID)
    }
   
    class func userHasProfilePictures(user: PFUser) -> Bool {
        let profilePictureMedium: PFFile? = user.objectForKey(kUserProfilePicMediumKey) as? PFFile
        let profilePictureSmall: PFFile? = user.objectForKey(kUserProfilePicSmallKey) as? PFFile
        
        return profilePictureMedium != nil && profilePictureSmall != nil
    }

    class func defaultProfilePicture() -> UIImage? {
        return UIImage(named: "AvatarPlaceholderBig.png")
    }
    
    // MARK Display Name

    class func firstNameForDisplayName(displayName: String?) -> String {
        if (displayName == nil || displayName!.characters.count == 0) {
            return "Someone"
        }
        
        let displayNameComponents: [String] = displayName!.componentsSeparatedByString(" ")
        var firstName = displayNameComponents[0]
        if firstName.characters.count > 100 {
            // truncate to 100 so that it fits in a Push payload
            firstName = firstName.subString(0, length: 100)
        }
        return firstName
    }

    // MARK User Following

    class func followUserInBackground(user: PFUser, block completionBlock: ((succeeded: Bool, error: NSError?) -> Void)?) {
        if user.objectId == PFUser.currentUser()!.objectId {
            return
        }
        
        let followActivity = PFObject(className: kActivityClassKey)
        followActivity.setObject(PFUser.currentUser()!, forKey: kActivityFromUserKey)
        followActivity.setObject(user, forKey: kActivityToUserKey)
        followActivity.setObject(kActivityTypeFollow, forKey: kActivityTypeKey)
        
        let followACL = PFACL(user: PFUser.currentUser()!)
        followACL.setPublicReadAccess(true)
        followActivity.ACL = followACL
        
        followActivity.saveInBackgroundWithBlock { (succeeded, error) in
            if completionBlock != nil {
                completionBlock!(succeeded: succeeded.boolValue, error: error)
            }
        }
        Cache.sharedCache.setFollowStatus(true, user: user)
    }

    class func followUserEventually(user: PFUser, block completionBlock: ((succeeded: Bool, error: NSError?) -> Void)?) {
        if user.objectId == PFUser.currentUser()!.objectId {
            return
        }
        
        let followActivity = PFObject(className: kActivityClassKey)
        followActivity.setObject(PFUser.currentUser()!, forKey: kActivityFromUserKey)
        followActivity.setObject(user, forKey: kActivityToUserKey)
        followActivity.setObject(kActivityTypeFollow, forKey: kActivityTypeKey)
        
        let followACL = PFACL(user: PFUser.currentUser()!)
        followACL.setPublicReadAccess(true)
        followActivity.ACL = followACL
        
        followActivity.saveEventually(completionBlock)
        Cache.sharedCache.setFollowStatus(true, user: user)
    }

    class func followUsersEventually(users: [PFUser], block completionBlock: ((succeeded: Bool, error: NSError?) -> Void)?) {
        for user: PFUser in users {
            Utility.followUserEventually(user, block: completionBlock)
            Cache.sharedCache.setFollowStatus(true, user: user)
        }
    }

    class func unfollowUserEventually(user: PFUser) {
        let query = PFQuery(className: kActivityClassKey)
        query.whereKey(kActivityFromUserKey, equalTo: PFUser.currentUser()!)
        query.whereKey(kActivityToUserKey, equalTo: user)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        query.findObjectsInBackgroundWithBlock { (followActivities, error) in
            // While normally there should only be one follow activity returned, we can't guarantee that.
            if error == nil {
                for followActivity: PFObject in followActivities as! [PFObject] {
                    followActivity.deleteEventually()
                }
            }
        }
        Cache.sharedCache.setFollowStatus(false, user: user)
    }

    class func unfollowUsersEventually(users: [PFUser]) {
        let query = PFQuery(className: kActivityClassKey)
        query.whereKey(kActivityFromUserKey, equalTo: PFUser.currentUser()!)
        query.whereKey(kActivityToUserKey, containedIn: users)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        query.findObjectsInBackgroundWithBlock { (activities, error) in
            for activity in activities as! [PFObject] {
                activity.deleteEventually()
            }
        }
        for user in users {
            Cache.sharedCache.setFollowStatus(false, user: user)
        }
    }
 
    // MARK Activities

    class func queryForActivitiesOnPhoto(photo: PFObject, cachePolicy: PFCachePolicy) -> PFQuery {
        let queryLikes: PFQuery = PFQuery(className: kActivityClassKey)
        queryLikes.whereKey(kActivityPhotoKey, equalTo: photo)
        queryLikes.whereKey(kActivityTypeKey, equalTo: kActivityTypeLike)
        
        let queryComments = PFQuery(className: kActivityClassKey)
        queryComments.whereKey(kActivityPhotoKey, equalTo: photo)
        queryComments.whereKey(kActivityTypeKey, equalTo: kActivityTypeComment)
        
        let query = PFQuery.orQueryWithSubqueries([queryLikes,queryComments])
        query.cachePolicy = cachePolicy
        query.includeKey(kActivityFromUserKey)
        query.includeKey(kActivityPhotoKey)

        return query
    }

    // MARK:- Shadow Rendering

    class func drawSideAndBottomDropShadowForRect(rect: CGRect, inContext context: CGContextRef) {
        // Push the context
        CGContextSaveGState(context)
        
        // Set the clipping path to remove the rect drawn by drawing the shadow
        let boundingRect: CGRect = CGContextGetClipBoundingBox(context)
        CGContextAddRect(context, boundingRect)
        CGContextAddRect(context, rect)
        CGContextEOClip(context)
        // Also clip the top and bottom
        CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0, rect.origin.y, rect.size.width + 20.0, rect.size.height + 10.0))
        
        // Draw shadow
        UIColor.blackColor().setFill()
        CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 7.0)
        CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y - 5.0, rect.size.width, rect.size.height + 5.0))
        // Save context
        CGContextRestoreGState(context)
    }
    
    class func drawSideAndTopDropShadowForRect(rect: CGRect, inContext context: CGContextRef) {
        // Push the context
        CGContextSaveGState(context)
        
        // Set the clipping path to remove the rect drawn by drawing the shadow
        let boundingRect: CGRect = CGContextGetClipBoundingBox(context)
        CGContextAddRect(context, boundingRect)
        CGContextAddRect(context, rect)
        CGContextEOClip(context)
        // Also clip the top and bottom
        CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0, rect.origin.y - 10.0, rect.size.width + 20.0, rect.size.height + 10.0))
        
        // Draw shadow
        UIColor.blackColor().setFill()
        CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 7.0)
        CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + 10.0))
        // Save context
        CGContextRestoreGState(context)
    }

    class func drawSideDropShadowForRect(rect: CGRect, inContext context: CGContextRef) {
        // Push the context 
        CGContextSaveGState(context)
        
        // Set the clipping path to remove the rect drawn by drawing the shadow
        let boundingRect: CGRect = CGContextGetClipBoundingBox(context)
        CGContextAddRect(context, boundingRect)
        CGContextAddRect(context, rect)
        CGContextEOClip(context)
        // Also clip the top and bottom
        CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0, rect.origin.y, rect.size.width + 20.0, rect.size.height))
        
        // Draw shadow
        UIColor.blackColor().setFill()
        CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 7.0)
        CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y - 5.0, rect.size.width, rect.size.height + 10.0))
        // Save context
        CGContextRestoreGState(context)
    }
}
