## Introduction

S-LAB에서 개발한 위치측위플랫폼 S-LBS를 이용하여 SSG PAY UX를 개선해 본 프로토타입 프로젝트 입니다.

## Specification

보통 때는 Today에 SSG PAY 위젯이 안 보이다가 S-LAB에 입구에 설정된 가상의 계산대 Zone 진입 이벤트(SSG PAY 1 진입)을 받으면 Today에 SSG PAY 위젯이 보여집니다.
첫 화면은 여섯 자리의 비밀번호를 입력받게 되어 있고, 아무 번호나 입력 후 Go를 선택하면 바로 바코드가 보입니다.

## Source

여러 가지 방법으로 Today 위젯을 테스트 해 보려다 보니 SSG PAY 위젯이 네 개가 들어있는데,
SSG PAY 4가 최종 위젯입니다.

<최초에 SSG PAY 위젯이 안 보이게 하는 소스>

TodayViewController.swift 에서

`
override func viewDidLoad() {
    ...
    NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4")
    ...
        
`

<SSG PAY 1 진입 이벤트 발생 시 위젯을 보여주는 소스>

CompainManager.m 에서


`
- (void)processCampaign:(SLBSZoneCampaignInfo*)zoneCampaignInfo {
    ...
    if ([foundCampaign.title compare:@"SSG Pay 1 진입"]==NSOrderedSame) {
        [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4"];
    }
    ...
`

## Contributors

궁금한 점이 있으시면 sucheolha@shinsegae.com으로 문의해 주세요.
