//
//  KalmanFilter.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "KalmanFilter.h"
//#import "LOCCoordinate.h"
#import "SLBSCoordination.h"

@implementation KalmanFilter {
    /** 현재 필터링 중인 map. map이 바뀌면 정보를 초기화 한다 */
    int _currentMap;
    /** 시스템 변수를 초기하할 필요가 있는지? */
    BOOL _first;
    /** kalman filter의 위치 상태 변수 */
    double _X[2];
    /** kalman filter의 위치 분산 */
    double _P[2][2];
}

-(instancetype) init {
    self = [super init];
    if(self != nil) {
        _first = YES;
        _currentMap = 0;
        [self initVariablesWithX:0. Y:0.];
    }
    return self;
}

-(void)initVariablesWithX:(double)x Y:(double)y {
    _P[0][0] = 1.0;
    _P[0][1] = 0.0;
    _P[1][0] = 0.0;
    _P[1][1] = 1.0;
    
    _X[0] = x;
    _X[1] = y;
}

#pragma mark ---------------------------------
#pragma mark Matrix Operations

-(void) inverse: (const double[2][2])x to: (double[2][2]) y {
    double det = x[0][0]*x[1][1] - x[0][1]*x[1][0];
    y[0][0] = x[1][1] / det;
    y[0][1] = -1. * x[0][1] / det;
    y[1][0] = -1. * x[1][0] / det;
    y[1][1] = x[0][0] / det;
}

-(void) add: (const double[2][2])x1 and: (const double[2][2])x2 to: (double[2][2])y {
    for ( int r = 0 ; r < 2 ; r++ ) {
        for ( int c = 0 ; c < 2 ; c++ ) {
            y[r][c] = x1[r][c] + x2[r][c];
        }
    }
}

-(void) add1: (const double[2])x1 and: (const double[2])x2 to: (double[2])y  {
    for ( int r = 0 ; r < 2 ; r++ ) {
        y[r] = x1[r] + x2[r];
    }
}

-(void) sub1: (const double[2])x1 with: (const double[2])x2 to: (double[2])y  {
    for ( int r = 0 ; r < 2 ; r++ ) {
        y[r] = x1[r] - x2[r];
    }
}

-(void) sub: (const double[2][2])x1 with: (const double[2][2])x2 to: (double[2][2])y  {
    for ( int r = 0 ; r < 2 ; r++ ) {
        for ( int c = 0 ; c < 2 ; c++ ) {
            y[r][c] = x1[r][c] - x2[r][c];
        }
    }
}

-(void) mul: (const double[2][2])x1 with: (const double[2][2])x2 to: (double[2][2])y {
    for ( int r = 0 ; r < 2 ; r++ ) {
        for ( int c = 0 ; c < 2 ; c++ ) {
            double sum = 0;
            for ( int i = 0 ; i < 2 ; i++ ) {
                sum += x1[r][i] * x2[i][c];
            }
            y[r][c] = sum;
        }
    }
    
}

-(void) mul1: (const double[2][2])x1 with: (const double[2])x2 to: (double[2])y {
    for ( int r = 0 ; r < 2 ; r++ ) {
        double sum = 0;
        for ( int i = 0 ; i < 2 ; i++ ) {
            sum += x1[r][i] * x2[i];
        }
        y[r] = sum;
    }
    
}

#pragma mark ---------------------------------
#pragma mark IPositionFilter


-(SLBSCoordination*)filter:(SLBSCoordination*)pos {
    // A is identity.
    // H is identity.
    // Q = I;
    // R = 5I;
    // z = [ x y ]';
    // x = [ x y ]';
    
    if ( _currentMap != [pos.mapID intValue] ) {
        _currentMap = [pos.mapID intValue];
        _first = YES;
    }
    
    if ( _first ) {
        [self initVariablesWithX:pos.x Y:pos.y];
        _first = false;
        return pos;
    }
    const double Z[2] = {pos.x, pos.y};
    double delta[2];
    const double Q[2][2] = {1.0, 0.0, 0.0, 1.0};
    const double R[2][2] = {5.0, 0.0, 0.0, 5.0};
    const double I[2][2] = {1.0, 0.0, 0.0, 1.0};
    double S[2][2];
    double K[2][2];
    double tmp[2][2];
    double tmp1[2];
    
    
    //P = P + Q;
    [self add:_P and:Q to:_P];
    
    //S = P + R;
    [self add:_P and:R to:S];
    
    //delta = Z - X;
    [self sub1:Z with:_X to:delta];
    
    //K = P * S_inv;
    // TODO: S_inv가 존재하지 않으면?
    [self inverse:S to:tmp];
    [self mul:_P with: tmp to: K];
    
    //X = X  + K * delta;
    [self mul1:K with: delta to: tmp1];
    [self add1:_X and: tmp1 to: _X];
    
    //P = (I - K) * P;
    [self sub:I with:K to:tmp];
    [self mul:tmp with:_P to: _P];
    
    SLBSCoordination* coordination = [[SLBSCoordination alloc] init];
    coordination.companyID = pos.companyID;
    coordination.branchID = pos.branchID;
    coordination.floorID = pos.floorID;
    coordination.mapID = pos.mapID;
    coordination.x = _X[0];
    coordination.y = _X[1];
    
    return coordination;
}

-(SLBSCoordination*)filter:(SLBSCoordination*)pos withVar:(double)var{
    // A is identity.
    // H is identity.
    // Q = I;
    // R = 5I;
    // z = [ x y ]';
    // x = [ x y ]';
    
    if ( _currentMap != [pos.mapID intValue] ) {
        _currentMap = [pos.mapID intValue];
        _first = YES;
    }
    
    if ( _first ) {
        [self initVariablesWithX:pos.x Y:pos.y];
        _first = false;
        return pos;
    }
    const double Z[2] = {pos.x, pos.y};
    double delta[2];
    const double Q[2][2] = {var, 0.0, 0.0, var};
    const double R[2][2] = {5.0, 0.0, 0.0, 5.0};
    const double I[2][2] = {1.0, 0.0, 0.0, 1.0};
    double S[2][2];
    double K[2][2];
    double tmp[2][2];
    double tmp1[2];
    
    
    //P = P + Q;
    [self add:_P and:Q to:_P];
    
    //S = P + R;
    [self add:_P and:R to:S];
    
    //delta = Z - X;
    [self sub1:Z with:_X to:delta];
    
    //K = P * S_inv;
    // TODO: S_inv가 존재하지 않으면?
    [self inverse:S to:tmp];
    [self mul:_P with: tmp to: K];
    
    //X = X  + K * delta;
    [self mul1:K with: delta to: tmp1];
    [self add1:_X and: tmp1 to: _X];
    
    //P = (I - K) * P;
    [self sub:I with:K to:tmp];
    [self mul:tmp with:_P to: _P];
    
    SLBSCoordination* coordination = [[SLBSCoordination alloc] init];
    coordination.companyID = pos.companyID;
    coordination.branchID = pos.branchID;
    coordination.floorID = pos.floorID;
    coordination.mapID = pos.mapID;
    coordination.x = _X[0];
    coordination.y = _X[1];
    
    return coordination;
}

@end
