// Copyright@Sdk2009
// Autogenerated from Pigeon (v22.6.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class PGNUser;
@class PGNMessage;

@interface PGNUser : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithName:(NSString *)name
    mobileNo:(NSInteger )mobileNo;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, assign) NSInteger  mobileNo;
@end

@interface PGNMessage : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithContent:(NSString *)content;
@property(nonatomic, copy) NSString * content;
@end

/// The codec used by all APIs.
NSObject<FlutterMessageCodec> *PGNGetUsersCodec(void);

@protocol PGNUserHostApi
/// @return `nil` only when `error != nil`.
- (nullable NSString *)getHostLanguageWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)saveUserUser:(PGNUser *)user completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
- (void)getUserWithCompletion:(void (^)(PGNUser *_Nullable, FlutterError *_Nullable))completion;
- (void)getAllUserWithCompletion:(void (^)(NSArray<PGNUser *> *_Nullable, FlutterError *_Nullable))completion;
@end

extern void SetUpPGNUserHostApi(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PGNUserHostApi> *_Nullable api);

extern void SetUpPGNUserHostApiWithSuffix(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PGNUserHostApi> *_Nullable api, NSString *messageChannelSuffix);


@protocol PGNMessageHostApi
- (void)sendMessageMessage:(PGNMessage *)message error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void SetUpPGNMessageHostApi(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PGNMessageHostApi> *_Nullable api);

extern void SetUpPGNMessageHostApiWithSuffix(id<FlutterBinaryMessenger> binaryMessenger, NSObject<PGNMessageHostApi> *_Nullable api, NSString *messageChannelSuffix);

NS_ASSUME_NONNULL_END
