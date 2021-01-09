//
//  LoginViewController.m
//  LiteracyAI
//
//  Created by Tommy Muir on 30/12/2020.
//

#import "LoginViewController.h"
#import "UserCollectionViewCell.h"
#import "NewUserCollectionViewCell.h"
#import "UserManager.h"
#import "NewUserViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_collectionView registerNib:[UserCollectionViewCell nib] forCellWithReuseIdentifier:@"UserCollectionViewCell"];
    [_collectionView registerNib:[NewUserCollectionViewCell nib] forCellWithReuseIdentifier:@"NewUserCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserCollectionViewCell* cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionViewCell" forIndexPath:indexPath];
        [cell configureForUser:[UserManager sharedInstance].users[indexPath.row]];
        return cell;
    }
    NewUserCollectionViewCell* cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"NewUserCollectionViewCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? [UserManager sharedInstance].users.count : 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //height is constrained to 200 so height here is ignored
    return CGSizeMake(self.view.frame.size.width, 200);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserManager* manager = [UserManager sharedInstance];
        User* user = manager.users[indexPath.row];
        manager.currentUser = user;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NewUserViewController* newUserVC = [storyboard instantiateViewControllerWithIdentifier:@"NewUserViewController"];
        [self.navigationController pushViewController:newUserVC animated:YES];
    }
}
@end
