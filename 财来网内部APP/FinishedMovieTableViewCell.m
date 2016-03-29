//
//  FinishedMovieTableViewCell.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/11/10.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "FinishedMovieTableViewCell.h"

@implementation FinishedMovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDetailMovieObj:(DetailMovieObj *)detailMovieObj
{
    _detailMovieObj = detailMovieObj;
    _movieImage.image = [UIImage imageNamed:@"video"];
    //_nameString.text = [detailMovieObj.nameString stringByAppendingString:[NSString stringWithFormat:@".%@",detailMovieObj.type]];
}
@end
