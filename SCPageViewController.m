
#import "SCPageViewController.h"
#import "SCImageViewController.h"
#import "SCImagesViewerData.h"


@interface SCPageViewController ()<UIPageViewControllerDelegate,UIActionSheetDelegate>

@property (nonatomic) UIButton *selectedButton;//右上角选中的图片标识

@property (nonatomic,strong) UILabel *badgeView;//已选中图片计数
@property (nonatomic) NSUInteger currentPageIndex;//当前页码
@end

@implementation SCPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [SCImagesViewerData sharedInstance].imagesArray = self.imagesArray;
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(handleDeleteButton:)];
    self.navigationItem.rightBarButtonItem = deleteItem;
    
    // start by viewing the photo tapped by the user
    SCImageViewController *startingPage = [SCImageViewController photoViewControllerForPageIndex:self.startingIndex];
    if (startingPage != nil)
    {
        self.currentPageIndex = self.startingIndex;
        self.delegate = self;
        self.dataSource = self;
        [self setViewControllers:@[startingPage]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}

#pragma mark - HandlButtonEvent

- (void)handleDeleteButton:(id)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"确定删除此张照片吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) destructiveButtonTitle:NSLocalizedString(@"删除照片", nil) otherButtonTitles:nil];
    [sheet showInView:self.view];
    
}

#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(SCImageViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    SCImageViewController *photoVC = [SCImageViewController photoViewControllerForPageIndex:index - 1];
    return photoVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(SCImageViewController *)vc
{
    NSUInteger index = vc.pageIndex;

    SCImageViewController *photoVC = [SCImageViewController photoViewControllerForPageIndex:index + 1];
    return photoVC;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    SCImageViewController *vc = (SCImageViewController *)[pageViewController.viewControllers firstObject];
    self.currentPageIndex = vc.pageIndex;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //删除
        NSUInteger newIndex = self.currentPageIndex;
        NSUInteger photoCount = [SCImagesViewerData sharedInstance].photoCount;
        if (newIndex == photoCount - 1 && photoCount != 1) {
            //设置最后一页时，取前面一页
            newIndex -= 1;
        }
        
        [[SCImagesViewerData sharedInstance] deletePhotoAtIndex:self.currentPageIndex];
        
        if ([SCImagesViewerData sharedInstance].photoCount == 0) {
            //照片数量为零时pop
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SCImageViewController *startingPage = [SCImageViewController photoViewControllerForPageIndex:newIndex];
            if (startingPage != nil){
                self.currentPageIndex = newIndex;
                [self setViewControllers:@[startingPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
            }
        }
        
    }else{
        //取消
    }
}
@end
