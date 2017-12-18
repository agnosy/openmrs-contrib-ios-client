//CredentialsLayer. Taken from http://stackoverflow.com/a/12440149/1849664

#import "CredentialsLayer.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation CredentialsLayer

#pragma mark - Methods

- (void)setUsername:(NSString *)username andPassword:(NSString *)password
{
    [self.requestSerializer clearAuthorizationHeader];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
}

#pragma mark - Initialization

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(!self)
        return nil;
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return self;
}

#pragma mark - Singleton Methods

+ (CredentialsLayer *)sharedManagerWithHost:(NSString *)host
{
    static dispatch_once_t pred;
    static CredentialsLayer *_sharedManager = nil;
    dispatch_once(&pred, ^ { _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:host]]; });
    if (![[_sharedManager.baseURL.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""] isEqual:[[NSURL URLWithString:host].absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""]]) {
        NSLog(@"######### baseURL.absoluteString [%@]", _sharedManager.baseURL.absoluteString);
        _sharedManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:host]];
    }
    _sharedManager.requestSerializer.timeoutInterval = 10;
    _sharedManager.responseSerializer = [AFJSONResponseSerializer new];
    return _sharedManager;
}


+ (CredentialsLayer *)sharedManagerWithHost:(NSString *)host andRequestSerializer:(AFHTTPResponseSerializer *)serializer {
    CredentialsLayer *manager = [self sharedManagerWithHost:host];
    manager.responseSerializer = serializer;
    return manager;
}

@end
