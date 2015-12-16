import UIKit
import ParseUI
import MBProgressHUD

let kCellInsetWidth: CGFloat = 0.0

class PhotoDetailsViewController : PFQueryTableViewController, UITextFieldDelegate, PhotoDetailsHeaderViewDelegate, BaseTextCellDelegate {
    private(set) var photo: PFObject?
    private var likersQueryInProgress: Bool
    
    private var commentTextField: UITextField?
    private var headerView: PhotoDetailsHeaderView?

    // MARK:- Initialization

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UtilityUserLikedUnlikedPhotoCallbackFinishedNotification, object: self.photo!)
    }
    
    init(photo aPhoto: PFObject) {
        self.likersQueryInProgress = false
        
        super.init(style: UITableViewStyle.Plain, className: nil)
        
        // The className to query on
        self.parseClassName = kActivityClassKey

        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = true

        // Whether the built-in pagination is enabled
        self.paginationEnabled = true
        
        // The number of comments to show per page
        self.objectsPerPage = 30
        
        self.photo = aPhoto
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- UIViewController
    override func viewDidLoad() {
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None

        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "LogoNavigationBar.png"))
        
        // Set table view properties
        let texturedBackgroundView = UIView(frame: self.view.bounds)
        texturedBackgroundView.backgroundColor = UIColor.blackColor()
        self.tableView!.backgroundView = texturedBackgroundView
        
        // Set table header
        self.headerView = PhotoDetailsHeaderView(frame: PhotoDetailsHeaderView.rectForView(), photo:self.photo!)
        self.headerView!.delegate = self
        
        self.tableView.tableHeaderView = self.headerView;
        
        // Set table footer
        let footerView = PhotoDetailsFooterView(frame: PhotoDetailsFooterView.rectForView())
        commentTextField = footerView.commentField
        commentTextField!.delegate = self
        self.tableView.tableFooterView = footerView

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: Selector("actionButtonAction:"))
        
        // Register to be notified when the keyboard will be shown to scroll the view
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("userLikedOrUnlikedPhoto:"), name: UtilityUserLikedUnlikedPhotoCallbackFinishedNotification, object: self.photo)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.headerView!.reloadLikeBar()
        
        // we will only hit the network if we have no cached data for this photo
        let hasCachedLikers: Bool = Cache.sharedCache.attributesForPhoto(self.photo!) != nil
        if !hasCachedLikers {
            self.loadLikers()
        }
    }


    // MARK:- UITableViewDelegate

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < self.objects!.count { // A comment row
            let object: PFObject? = self.objects![indexPath.row] as? PFObject
            
            if object != nil {
                let commentString: String = object!.objectForKey(kActivityContentKey) as! String
                
                let commentAuthor: PFUser? = object!.objectForKey(kActivityFromUserKey) as? PFUser
                
                var nameString = ""
                if commentAuthor != nil {
                    nameString = commentAuthor!.objectForKey(kUserDisplayNameKey) as! String
                }
                
                return ActivityCell.heightForCellWithName(nameString, contentString: commentString, cellInsetWidth: kCellInsetWidth)
            }
        }
        
        // The pagination row
        return 44.0
    }


    // MARK:- PFQueryTableViewController

    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.whereKey(kActivityPhotoKey, equalTo: self.photo!)
        query.includeKey(kActivityFromUserKey)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeComment)
        query.orderByAscending("createdAt")

        query.cachePolicy = PFCachePolicy.NetworkOnly

        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        //
        // If there is no network connection, we will hit the cache first.
        if self.objects!.count == 0 || UIApplication.sharedApplication().delegate!.performSelector(Selector("isParseReachable")) != nil {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        return query
    }

    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)

        self.headerView!.reloadLikeBar()
        self.loadLikers()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellID = "CommentCell"

        // Try to dequeue a cell and create one if necessary
        var cell: BaseTextCell? = tableView.dequeueReusableCellWithIdentifier(cellID) as? BaseTextCell
        if cell == nil {
            cell = BaseTextCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellID)
            cell!.cellInsetWidth = kCellInsetWidth
            cell!.delegate = self
        }
        
        cell!.user = object!.objectForKey(kActivityFromUserKey) as? PFUser
        cell!.setContentText(object!.objectForKey(kActivityContentKey) as! String)
        cell!.setDate(object!.createdAt!)

        return cell
    }

    override func tableView(tableView: UITableView, cellForNextPageAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell? {
        let CellIdentifier = "NextPageDetails"
        
        var cell: LoadMoreCell? = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as? LoadMoreCell
        
        if cell == nil {
            cell = LoadMoreCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellIdentifier)
            cell!.cellInsetWidth = kCellInsetWidth
            cell!.hideSeparatorTop = true
        }
        
        return cell
    }


    // MARK:- UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let trimmedComment = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmedComment.characters.count != 0 && self.photo!.objectForKey(kPhotoUserKey) != nil {
            let comment = PFObject(className: kActivityClassKey)
            comment.setObject(trimmedComment, forKey: kActivityContentKey) // Set comment text
            comment.setObject(self.photo!.objectForKey(kPhotoUserKey)!, forKey: kActivityToUserKey) // Set toUser
            comment.setObject(PFUser.currentUser()!, forKey: kActivityFromUserKey) // Set fromUser
            comment.setObject(kActivityTypeComment, forKey:kActivityTypeKey)
            comment.setObject(self.photo!, forKey: kActivityPhotoKey)
            
            let ACL = PFACL(user: PFUser.currentUser()!)
            ACL.setPublicReadAccess(true)
            ACL.setWriteAccess(true, forUser: self.photo!.objectForKey(kPhotoUserKey) as! PFUser)
            comment.ACL = ACL

            Cache.sharedCache.incrementCommentCountForPhoto(self.photo!)
            
            // Show HUD view
            MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
            
            // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
            let timer: NSTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("handleCommentTimeout:"), userInfo: ["comment": comment], repeats: false)

            comment.saveEventually { (succeeded, error) in
                timer.invalidate()
                
                if error != nil && error!.code == PFErrorCode.ErrorObjectNotFound.rawValue {
                    Cache.sharedCache.decrementCommentCountForPhoto(self.photo!)
                    
                    let alertController = UIAlertController(title: NSLocalizedString("Could not post comment", comment: ""), message: NSLocalizedString("This photo is no longer available", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
                    let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    self.navigationController!.popViewControllerAnimated(true)
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(PhotoDetailsViewControllerUserCommentedOnPhotoNotification, object: self.photo!, userInfo: ["comments": self.objects!.count + 1])
                
                MBProgressHUD.hideHUDForView(self.view.superview, animated: true)
                self.loadObjects()
            }
        }
        
        textField.text = ""
        return textField.resignFirstResponder()
    }

    // MARK:- UIScrollViewDelegate

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        commentTextField!.resignFirstResponder()
    }

    // MARK:- BaseTextCellDelegate

    func cell(cellView: BaseTextCell, didTapUserButton aUser: PFUser) {
        self.shouldPresentAccountViewForUser(aUser)
    }

    // MARK:- PhotoDetailsHeaderViewDelegate

    func photoDetailsHeaderView(headerView: PhotoDetailsHeaderView, didTapUserButton button: UIButton, user: PFUser) {
        self.shouldPresentAccountViewForUser(user)
    }


    // MARK:- ()

    func actionButtonAction(sender: AnyObject) {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        if self.currentUserOwnsPhoto() {
            let deletePhotoAction = UIAlertAction(title: NSLocalizedString("Delete Photo", comment: ""), style: UIAlertActionStyle.Destructive, handler: { _ in
                // prompt to delete
                self.showConfirmDeletePhotoActionSheet()
            })
            actionController.addAction(deletePhotoAction)
        }
        let sharePhotoAction = UIAlertAction(title: NSLocalizedString("Share Photo", comment: ""), style: UIAlertActionStyle.Default, handler: { _ in
            self.activityButtonAction(self)
        })
        actionController.addAction(sharePhotoAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        actionController.addAction(cancelAction)
        
        presentViewController(actionController, animated: true, completion: nil)
    }
    
    func showConfirmDeletePhotoActionSheet() {
        // prompt to delete
        let actionController = UIAlertController(title: NSLocalizedString("Are you sure you want to delete this photo?", comment: ""), message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Yes, delete photo", comment: ""), style: UIAlertActionStyle.Destructive, handler: { _ in
            self.shouldDeletePhoto()
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionController.addAction(deleteAction)
        actionController.addAction(cancelAction)
        
        presentViewController(actionController, animated: true, completion: nil)
    }

    func activityButtonAction(sender: AnyObject) {
        if self.photo!.objectForKey(kPhotoPictureKey)!.isDataAvailable() {
            self.showShareSheet()
        } else {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.photo!.objectForKey(kPhotoPictureKey)!.getDataInBackgroundWithBlock { (data, error) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if error == nil {
                    self.showShareSheet()
                }
            }
        }
    }

    func showShareSheet() {
        self.photo!.objectForKey(kPhotoPictureKey)!.getDataInBackgroundWithBlock { (data, error) in
            if error == nil {
                var activityItems = [AnyObject]()
                            
                // Prefill caption if this is the original poster of the photo, and then only if they added a caption initially.
                if (PFUser.currentUser()!.objectId == self.photo!.objectForKey(kPhotoUserKey)!.objectId) && self.objects!.count > 0 {
                    let firstActivity: PFObject = self.objects![0] as! PFObject
                    if firstActivity.objectForKey(kActivityFromUserKey)!.objectId == self.photo!.objectForKey(kPhotoUserKey)!.objectId {
                        let commentString = firstActivity.objectForKey(kActivityContentKey)
                        activityItems.append(commentString!)
                    }
                }
                
                activityItems.append(UIImage(data: data!)!)
                activityItems.append(NSURL(string:  "https://anypic.org/#pic/\(self.photo!.objectId!)")!)
                
                let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                self.navigationController!.presentViewController(activityViewController, animated: true, completion: nil)
            }
        }
    }

    func handleCommentTimeout(aTimer: NSTimer) {
        MBProgressHUD.hideHUDForView(self.view.superview, animated: true)
        
        let alertController = UIAlertController(title: NSLocalizedString("New Comment", comment: ""), message: NSLocalizedString("Your comment will be posted next time there is an Internet connection.", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func shouldPresentAccountViewForUser(user: PFUser) {
        let accountViewController = AccountViewController(user: user)
        print("Presenting account view controller with user: \(user)")
        self.navigationController!.pushViewController(accountViewController, animated: true)
    }

    func backButtonAction(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }

    func userLikedOrUnlikedPhoto(note: NSNotification) {
        self.headerView!.reloadLikeBar()
    }

    func keyboardWillShow(note: NSNotification) {
        // Scroll the view to the comment text box
        let info = note.userInfo
        let kbSize: CGSize = (info![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size
        self.tableView.setContentOffset(CGPointMake(0.0, self.tableView.contentSize.height-kbSize.height), animated: true)
    }

    func loadLikers() {
        if self.likersQueryInProgress {
            return
        }

        self.likersQueryInProgress = true
        let query: PFQuery = Utility.queryForActivitiesOnPhoto(photo!, cachePolicy: PFCachePolicy.NetworkOnly)
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            self.likersQueryInProgress = false
            if error != nil {
                self.headerView!.reloadLikeBar()
                return
            }
            
            var likers = [PFUser]()
            var commenters = [PFUser]()
            
            var isLikedByCurrentUser = false
            
            for activity in objects! {
                if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeLike && activity.objectForKey(kActivityFromUserKey) != nil {
                    likers.append(activity.objectForKey(kActivityFromUserKey) as! PFUser)
                } else if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeComment && activity.objectForKey(kActivityFromUserKey) != nil {
                    commenters.append(activity.objectForKey(kActivityFromUserKey) as! PFUser)
                }
                
                if ((activity.objectForKey(kActivityFromUserKey) as? PFObject)?.objectId) == PFUser.currentUser()!.objectId {
                    if (activity.objectForKey(kActivityTypeKey) as! String) == kActivityTypeLike {
                        isLikedByCurrentUser = true
                    }
                }
            }
            
            Cache.sharedCache.setAttributesForPhoto(self.photo!, likers: likers, commenters: commenters, likedByCurrentUser: isLikedByCurrentUser)
            self.headerView!.reloadLikeBar()
        }
    }

    func currentUserOwnsPhoto() -> Bool {
        return (self.photo!.objectForKey(kPhotoUserKey) as! PFObject).objectId == PFUser.currentUser()!.objectId
    }

    func shouldDeletePhoto() {
        // Delete all activites related to this photo
        let query = PFQuery(className: kActivityClassKey)
        query.whereKey(kActivityPhotoKey, equalTo: self.photo!)
        query.findObjectsInBackgroundWithBlock { (activities, error) in
            if error == nil {
                for activity in activities! {
                    activity.deleteEventually()
                }
            }
            
            // Delete photo
            self.photo!.deleteEventually()
        }
        NSNotificationCenter.defaultCenter().postNotificationName(PhotoDetailsViewControllerUserDeletedPhotoNotification, object: self.photo!.objectId)
        self.navigationController!.popViewControllerAnimated(true)
    }
}
