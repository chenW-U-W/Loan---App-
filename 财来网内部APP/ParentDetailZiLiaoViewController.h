//
//  ParentDetailZiLiaoViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/17.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentDetailZiLiaoViewController : UIViewController
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *totalArray;
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *itemString;
@end
