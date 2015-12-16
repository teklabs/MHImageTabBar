//
//  AccountViewController.swift
//  IOStickyHeader
//
//  Created by ben on 29/06/2015.
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//

import UIKit
//import IOStickyHeader
import Parse
import ParseUI

//class AccountViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
class AccountViewController: PhotoTimelineViewController {
    
    var user: PFUser?
    private var headerView: UIView?
    
    //@IBOutlet weak var collectionView: UICollectionView!
    
    //let headerNib = UINib(nibName: "ProfileHeader", bundle: NSBundle.mainBundle())
    var section: Array<Array<String>> = [[]]
    
    // MARK:- Initialization
    
    init(user aUser: PFUser) {
        super.init(style: UITableViewStyle.Plain, className: nil)
        self.user = aUser
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK:- UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.user == nil {
            self.user = PFUser.currentUser()!
            PFUser.currentUser()!.fetchIfNeeded()
        }
       
        /*
        self.section = [
            [
                "Item 1",
                "Item 2",
                "Item 3",
                "Item 4",
                "Item 5",
                "Item 6",
                "Item 7",
                "Item 8",
                "Item 9",
                "Item 10",
                "Item 11",
                "Item 12",
                "Item 13",
                "Item 14",
                "Item 15",
                "Item 16",
                "Item 17",
                "Item 18",
                "Item 19",
                "Item 20",
            ]
        ]
*/
        
        //self.setupCollectionView()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "LogoNavigationBar.png"))
        
        self.headerView = UIView(frame: CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 222.0))
        self.headerView!.backgroundColor = UIColor.clearColor() // should be clear, this will be the container for our avatar, photo count, follower count, following count, and so on
        
        let texturedBackgroundView: UIView = UIView(frame: self.view.bounds)
        texturedBackgroundView.backgroundColor = UIColor.blackColor()
        self.tableView.backgroundView = texturedBackgroundView
        
        let profilePictureBackgroundView = UIView(frame: CGRectMake(94.0, 38.0, 132.0, 132.0))
        profilePictureBackgroundView.backgroundColor = UIColor.darkGrayColor()
        profilePictureBackgroundView.alpha = 0.0
        var layer: CALayer = profilePictureBackgroundView.layer
        layer.cornerRadius = 66.0
        layer.masksToBounds = true
        self.headerView!.addSubview(profilePictureBackgroundView)
        
        let profilePictureImageView: PFImageView = PFImageView(frame: CGRectMake(94.0, 38.0, 132.0, 132.0))
        self.headerView!.addSubview(profilePictureImageView)
        profilePictureImageView.contentMode = UIViewContentMode.ScaleAspectFill
        layer = profilePictureImageView.layer
        layer.cornerRadius = 66.0
        layer.masksToBounds = true
        profilePictureImageView.alpha = 0.0
        
        if Utility.userHasProfilePictures(self.user!) {
            let imageFile: PFFile? = self.user!.objectForKey(kUserProfilePicMediumKey) as? PFFile
            profilePictureImageView.file = imageFile
            profilePictureImageView.loadInBackground { (image, error) in
                if error == nil {
                    UIView.animateWithDuration(0.2, animations: {
                        profilePictureBackgroundView.alpha = 1.0
                        profilePictureImageView.alpha = 1.0
                    })
                    
                    let backgroundImageView  = UIImageView(image: image!.applyDarkEffect())
                    backgroundImageView.frame = self.tableView.backgroundView!.bounds
                    backgroundImageView.alpha = 0.0
                    self.tableView.backgroundView!.addSubview(backgroundImageView)
                    
                    UIView.animateWithDuration(0.2, animations: {
                        backgroundImageView.alpha = 1.0
                    })
                }
            }
        } else {
            profilePictureImageView.image = Utility.defaultProfilePicture()!
            UIView.animateWithDuration(0.2, animations: {
                profilePictureBackgroundView.alpha = 1.0
                profilePictureImageView.alpha = 1.0
            })
            
            let backgroundImageView = UIImageView(image: Utility.defaultProfilePicture()!.applyDarkEffect())
            backgroundImageView.frame = self.tableView.backgroundView!.bounds
            backgroundImageView.alpha = 0.0
            self.tableView.backgroundView!.addSubview(backgroundImageView)
            
            UIView.animateWithDuration(0.2, animations: {
                backgroundImageView.alpha = 1.0
            })
        }
        
        let photoCountIconImageView: UIImageView = UIImageView(image: nil)
        photoCountIconImageView.image = UIImage(named: "IconPics.png")
        photoCountIconImageView.frame = CGRectMake(26.0, 50.0, 45.0, 37.0)
        self.headerView!.addSubview(photoCountIconImageView)
        
        let photoCountLabel = UILabel(frame: CGRectMake(0.0, 94.0, 92.0, 22.0))
        photoCountLabel.textAlignment = NSTextAlignment.Center
        photoCountLabel.backgroundColor = UIColor.clearColor()
        photoCountLabel.textColor = UIColor.whiteColor()
        photoCountLabel.shadowColor = UIColor(white: 0.0, alpha: 0.300)
        photoCountLabel.shadowOffset = CGSizeMake(0.0, -1.0)
        photoCountLabel.font = UIFont.boldSystemFontOfSize(14.0)
        self.headerView!.addSubview(photoCountLabel)
        
        let followersIconImageView = UIImageView(image: nil)
        followersIconImageView.image = UIImage(named: "IconFollowers.png")
        followersIconImageView.frame = CGRectMake(247.0, 50.0, 52.0, 37.0)
        self.headerView!.addSubview(followersIconImageView)
        
        let followerCountLabel = UILabel(frame: CGRectMake(226.0, 94.0, self.headerView!.bounds.size.width - 226.0, 16.0))
        followerCountLabel.textAlignment = NSTextAlignment.Center
        followerCountLabel.backgroundColor = UIColor.clearColor()
        followerCountLabel.textColor = UIColor.whiteColor()
        followerCountLabel.shadowColor = UIColor(white: 0.0, alpha: 0.300)
        followerCountLabel.shadowOffset = CGSizeMake(0.0, -1.0)
        followerCountLabel.font = UIFont.boldSystemFontOfSize(12.0)
        self.headerView!.addSubview(followerCountLabel)
        
        let followingCountLabel = UILabel(frame: CGRectMake(226.0, 110.0, self.headerView!.bounds.size.width - 226.0, 16.0))
        followingCountLabel.textAlignment = NSTextAlignment.Center
        followingCountLabel.backgroundColor = UIColor.clearColor()
        followingCountLabel.textColor = UIColor.whiteColor()
        followingCountLabel.shadowColor = UIColor(white: 0.0, alpha: 0.300)
        followingCountLabel.shadowOffset = CGSizeMake(0.0, -1.0)
        followingCountLabel.font = UIFont.boldSystemFontOfSize(12.0)
        self.headerView!.addSubview(followingCountLabel)
        
        let userDisplayNameLabel = UILabel(frame: CGRectMake(0, 176.0, self.headerView!.bounds.size.width, 22.0))
        userDisplayNameLabel.textAlignment = NSTextAlignment.Center
        userDisplayNameLabel.backgroundColor = UIColor.clearColor()
        userDisplayNameLabel.textColor = UIColor.whiteColor()
        userDisplayNameLabel.shadowColor = UIColor(white: 0.0, alpha: 0.300)
        userDisplayNameLabel.shadowOffset = CGSizeMake(0.0, -1.0)
        userDisplayNameLabel.text = self.user!.objectForKey("displayName") as? String
        userDisplayNameLabel.font = UIFont.boldSystemFontOfSize(18.0)
        self.headerView!.addSubview(userDisplayNameLabel)
        
        photoCountLabel.text = "0 photos"
        
        let queryPhotoCount = PFQuery(className: "Photo")
        queryPhotoCount.whereKey(kPhotoUserKey, equalTo: self.user!)
        queryPhotoCount.cachePolicy = PFCachePolicy.CacheThenNetwork
        queryPhotoCount.countObjectsInBackgroundWithBlock { (number, error) in
            if error == nil {
                let appendS = (number == 1) ? "" : "s"
                photoCountLabel.text = "\(number) photo\(appendS)"
                Cache.sharedCache.setPhotoCount(Int(number), user: self.user!)
            }
        }
        
        followerCountLabel.text = "0 followers"
        
        let queryFollowerCount = PFQuery(className: kActivityClassKey)
        queryFollowerCount.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        queryFollowerCount.whereKey(kActivityToUserKey, equalTo: self.user!)
        queryFollowerCount.cachePolicy = PFCachePolicy.CacheThenNetwork
        queryFollowerCount.countObjectsInBackgroundWithBlock { (number, error) in
            if error == nil {
                let appendS = (number == 1) ? "" : "s"
                followerCountLabel.text = "\(number) follower\(appendS)"
            }
        }
        
        let followingDictionary: [NSObject: AnyObject]? = PFUser.currentUser()!.objectForKey("following") as! [NSObject: AnyObject]?
        followingCountLabel.text = "0 following"
        if followingDictionary != nil {
            followingCountLabel.text = "\(followingDictionary!.count) following"
        }
        
        let queryFollowingCount = PFQuery(className: kActivityClassKey)
        queryFollowingCount.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        queryFollowingCount.whereKey(kActivityFromUserKey, equalTo: self.user!)
        queryFollowingCount.cachePolicy = PFCachePolicy.CacheThenNetwork
        queryFollowingCount.countObjectsInBackgroundWithBlock { (number, error) in
            if error == nil {
                followingCountLabel.text = "\(number) following"
            }
        }
        
        if self.user!.objectId != PFUser.currentUser()!.objectId {
            let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            loadingActivityIndicatorView.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingActivityIndicatorView)
            
            // check if the currentUser is following this user
            let queryIsFollowing = PFQuery(className: kActivityClassKey)
            queryIsFollowing.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
            queryIsFollowing.whereKey(kActivityToUserKey, equalTo: self.user!)
            queryIsFollowing.whereKey(kActivityFromUserKey, equalTo: PFUser.currentUser()!)
            queryIsFollowing.cachePolicy = PFCachePolicy.CacheThenNetwork
            queryIsFollowing.countObjectsInBackgroundWithBlock { (number, error) in
                if error != nil && error!.code != PFErrorCode.ErrorCacheMiss.rawValue {
                    print("Couldn't determine follow relationship: \(error)")
                    self.navigationItem.rightBarButtonItem = nil
                } else {
                    if number == 0 {
                        self.configureFollowButton()
                    } else {
                        self.configureUnfollowButton()
                    }
                }
            }
        }
    }
    // MARK:- PFQueryTableViewController
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        self.tableView.tableHeaderView = headerView!
    }
    
    override func queryForTable() -> PFQuery {
        if self.user == nil {
            let query = PFQuery(className: self.parseClassName!)
            query.limit = 0
            return query
        }
        
        let query = PFQuery(className: self.parseClassName!)
        query.cachePolicy = PFCachePolicy.NetworkOnly
        if self.objects!.count == 0 {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        query.whereKey(kPhotoUserKey, equalTo: self.user!)
        query.orderByDescending("createdAt")
        query.includeKey(kPhotoUserKey)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForNextPageAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell? {
        let LoadMoreCellIdentifier = "LoadMoreCell"
        
        var cell: LoadMoreCell? = tableView.dequeueReusableCellWithIdentifier(LoadMoreCellIdentifier) as? LoadMoreCell
        if cell == nil {
            cell = LoadMoreCell(style: UITableViewCellStyle.Default, reuseIdentifier: LoadMoreCellIdentifier)
            cell!.selectionStyle = UITableViewCellSelectionStyle.None
            cell!.separatorImageTop!.image = UIImage(named: "SeparatorTimelineDark.png")
            cell!.hideSeparatorBottom = true
            cell!.mainView!.backgroundColor = UIColor.clearColor()
        }
        return cell
    }
    
    
    // MARK:- ()
    
    func followButtonAction(sender: AnyObject) {
        let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        loadingActivityIndicatorView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingActivityIndicatorView)
        
        self.configureUnfollowButton()
        
        Utility.followUserEventually(self.user!, block: { (succeeded, error) in
            if error != nil {
                self.configureFollowButton()
            }
        })
    }
    
    func unfollowButtonAction(sender: AnyObject) {
        let loadingActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        loadingActivityIndicatorView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: loadingActivityIndicatorView)
        
        self.configureFollowButton()
        
        Utility.unfollowUserEventually(self.user!)
    }
    
    func backButtonAction(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func configureFollowButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("followButtonAction:"))
        Cache.sharedCache.setFollowStatus(false, user: self.user!)
    }
    
    func configureUnfollowButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unfollow", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("unfollowButtonAction:"))
        Cache.sharedCache.setFollowStatus(true, user: self.user!)
    }
}

   /* }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/
/*
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let layout: IOStickyHeaderFlowLayout = self.collectionView.collectionViewLayout as? IOStickyHeaderFlowLayout {
            layout.parallaxHeaderReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 274)
            layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 180)
            layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, layout.itemSize.height)
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = true
            self.collectionView.collectionViewLayout = layout
        }
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.collectionView.registerNib(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "header")
    }


    //MARK: UICollectionViewDataSource & UICollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.section.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.section[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: IOCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! IOCell
        
        let obj = self.section[indexPath.section][indexPath.row]
        
        cell.lblTitle.text = obj
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, 50);
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case IOStickyHeaderParallaxHeader:
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as! ProfileHeader
            return cell
        default:
            assert(false, "Unexpected element kind")
        }
    }

}
*/
