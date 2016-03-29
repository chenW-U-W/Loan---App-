//
//  MovieInformationViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/23.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiYaWuInformationViewController : UIViewController
//barItem
@property (weak, nonatomic) IBOutlet UIButton *bar_removeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *bar_scanBtn;

@property (nonatomic,strong) NSString *userID;

@property (nonatomic,strong) UICollectionView *movieContractCollectionView;

@property (weak, nonatomic) IBOutlet UIView *barView;

@property (nonatomic,strong) NSString *detailItemString;
- (IBAction)barItenBtnclick:(id)sender;

@end
