#import "FlutterGeniusScanPlugin.h"

#import <GSSDK/GSSDK.h>

@interface FlutterGeniusScanPlugin ()

@property (nonatomic, strong) GSKScanFlow *scanner;

@end

@implementation FlutterGeniusScanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_genius_scan"
            binaryMessenger:[registrar messenger]];
  FlutterGeniusScanPlugin* instance = [[FlutterGeniusScanPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setLicenseKey" isEqualToString:call.method]) {
    [GSK setLicenseKey:call.arguments[@"licenseKey"] autoRefresh:call.arguments[@"autoRefresh"]];
    result(nil);
  } else if ([@"scanWithConfiguration" isEqualToString:call.method]) {

    NSDictionary *scanOptions = call.arguments;

    NSError *error = nil;
    GSKScanFlowConfiguration *configuration = [GSKScanFlowConfiguration configurationWithDictionary:scanOptions error:&error];
    if (!configuration) {
        result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@ error %d", error.domain, error.code]
                            message:error.localizedDescription
                            details:nil]);
        return;
    }

    self.scanner = [GSKScanFlow scanFlowWithConfiguration:configuration];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController* viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [self.scanner startFromViewController:viewController onSuccess:^(GSKScanFlowResult * _Nonnull sdkResult) {
            result([sdkResult dictionary]);
        } failure:^(NSError *error) {
            result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@ error %d", error.domain, error.code]
                message:error.localizedDescription
                details:nil]);
        }];
    });

  } else if ([@"generateDocument" isEqualToString:call.method]) {

    NSDictionary *documentDictionary = call.arguments[@"document"];
    NSDictionary *configurationDictionary = call.arguments[@"configuration"];

    NSError *error = nil;
    GSKDocumentGeneratorConfiguration *configuration = [[GSKDocumentGeneratorConfiguration alloc] initWithDictionary:configurationDictionary error:&error];
    if (!configuration) {
      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@ error %d", error.domain, error.code]
                          message:error.localizedDescription
                          details:nil]);
      return;
    }

    GSKPDFDocument *document = [[GSKPDFDocument alloc] initWithDictionary:documentDictionary error:&error];
    if (!document) {
      result([FlutterError errorWithCode:[NSString stringWithFormat:@"%@ error %d", error.domain, error.code]
                          message:error.localizedDescription
                          details:nil]);
      return;
    }

    BOOL success = [[GSKDocumentGenerator alloc] generate:document configuration:configuration error:&error];
    if (success) {
      result(nil);
    } else {
      result([FlutterError errorWithCode:@"document_generation_error"
                        message:@"Document generation failed."
                        details:nil]);
    }

  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
