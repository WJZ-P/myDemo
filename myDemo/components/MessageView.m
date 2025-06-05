#import "MessageView.h"
#import "MessageCell.h"

@interface MessageView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MessageModel *> *messages;

@end

@implementation MessageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 初始化消息数组
    _messages = [NSMutableArray array];
    
    // 创建 TableView
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tableView];
    
    // 注册自定义单元格
    [_tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
    
    // 设置 TableView 约束
    [NSLayoutConstraint activateConstraints:@[
        [_tableView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

#pragma mark - Public Methods

- (void)addMessage:(MessageModel *)message {
    [_messages addObject:message];
    
    // 在主线程更新 UI
    dispatch_async(dispatch_get_main_queue(), ^{// dispatch_async 是异步执行，不会阻塞主线程，第一个参数是队列，第二个参数是block
        [self.tableView reloadData];
        
        // 滚动到底部
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)clearAllMessages {
    [_messages removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    
    MessageModel *message = _messages[indexPath.row];
    [cell configureWithMessage:message];
    
    return cell;
}

@end
