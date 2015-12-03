## Introduction

S-LAB���� ������ ��ġ�����÷��� S-LBS�� �̿��Ͽ� SSG PAY UX�� ������ �� ������Ÿ�� ������Ʈ �Դϴ�.

## Specification

���� ���� Today�� SSG PAY ������ �� ���̴ٰ� S-LAB�� �Ա��� ������ ������ ���� Zone ���� �̺�Ʈ(SSG PAY 1 ����)�� ������ Today�� SSG PAY ������ �������ϴ�.
ù ȭ���� ���� �ڸ��� ��й�ȣ�� �Է¹ް� �Ǿ� �ְ�, �ƹ� ��ȣ�� �Է� �� Go�� �����ϸ� �ٷ� ���ڵ尡 ���Դϴ�.

## Source

���� ���� ������� Today ������ �׽�Ʈ �� ������ ���� SSG PAY ������ �� ���� ����ִµ�,
SSG PAY 4�� ���� �����Դϴ�.

<���ʿ� SSG PAY ������ �� ���̰� �ϴ� �ҽ�>

TodayViewController.swift ����

`
override func viewDidLoad() {
    ...
    NCWidgetController.widgetController().setHasContent(false, forWidgetWithBundleIdentifier: "com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4")
    ...
        
`

<SSG PAY 1 ���� �̺�Ʈ �߻� �� ������ �����ִ� �ҽ�>

CompainManager.m ����


`
- (void)processCampaign:(SLBSZoneCampaignInfo*)zoneCampaignInfo {
    ...
    if ([foundCampaign.title compare:@"SSG Pay 1 ����"]==NSOrderedSame) {
        [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4"];
    }
    ...
`

## Contributors

�ñ��� ���� �����ø� sucheolha@shinsegae.com���� ������ �ּ���.
