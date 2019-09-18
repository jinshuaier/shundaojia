//
//  ZYYImageView.h
//  CustomDemo
//
//  Created by zhngyy on 16/7/12.
//  Copyright © 2016年 zhangyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYYImageView : UIView
//本地图片的名字
@property (nonatomic,copy)NSString *localImageName;
//网络图片的URLString
@property (nonatomic,copy)NSString *webImageURLString;
//网络图片的URL类
@property (nonatomic,strong)NSURL *webImageURL;
//图片类Image
@property (nonatomic,strong)UIImage *image;
//占位图(这个要在webImageURL之前调用)
@property (nonatomic,copy)NSString *webImagePlacehold;

/**
 *  本地图片
 *
 *  @param frame     frame
 *  @param imageName 本地图片名字
 *
 *  @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame
          imageWithLocalName:(NSString *)imageName;

/**
 *  网络图片
 *
 *  @param frame     frame
 *  @param imageName 网络地址（string）类型
 *  @param placeholdName 占位图
 *
 *  @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame
          imageWithURLString:(NSString *)imageName
               placeholdName:(NSString *)placeImageName;

/**
 *  直接赋值图片
 *
 *  @param frame frame
 *  @param image 图片（UIImage）类型
 *
 *  @return 返回实例
 */
-(instancetype)initWithFrame:(CGRect)frame
                       image:(UIImage *)image;

/**
 *  网络URL图片
 *
 *  @param frame         frame
 *  @param imageURL      URL类型
 *  @param placeholdName 占位图
 *
 *  @return 实例
 */
-(instancetype)initWithFrame:(CGRect)frame
                    imageURL:(NSURL *)imageURL
               placeholdName:(NSString *)placeholdName;

@end
