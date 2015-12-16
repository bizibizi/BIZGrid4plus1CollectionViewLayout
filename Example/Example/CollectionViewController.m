//
//  CollectionViewController.m
//  ExampleBIZCollectionViewLayout4plus1Grid
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "CollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "BIZGrid4plus1CollectionViewLayout.h"


@interface CollectionViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation CollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataSource];
    
    //Create in code
//    self.collectionView.collectionViewLayout = [[BIZGrid4plus1CollectionViewLayout alloc] init];
}

- (void)loadDataSource
{
    self.dataSource = [NSMutableArray array];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *directoryURL = [NSURL URLWithString:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"images"]];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directoryURL includingPropertiesForKeys:keys options:0 errorHandler:^(NSURL *url, NSError *error) {
        if (error) {
            NSLog(@"%@", error.debugDescription);
        }
        return YES;
    }];
    for (NSURL *url in enumerator)
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        [self.dataSource addObject:image];
    }
}


#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (ImageCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ImageCollectionViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.imageView.image = self.dataSource[indexPath.row];
    return cell;
}


@end
