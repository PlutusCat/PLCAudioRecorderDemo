//
//  MainTableCell.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/26.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "MainTableCell.h"

@interface MainTableCell ()


@end

@implementation MainTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MainTableCell";
    MainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MainTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        
    }
    
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
