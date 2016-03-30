//
//  ViewController.m
//  CoreBluetoothDemo
//
//  Created by EMPty on 3/31/16.
//  Copyright (c) 2016 EMPty. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic) NSMutableArray* peripheralArray;
@property (nonatomic) CBCentralManager* center;
@end

@implementation ViewController


//懒加载
- (NSMutableArray*)peripheralArray
{
    if (!_peripheralArray) {
        _peripheralArray = [[NSMutableArray alloc]init];
        
    }
    return _peripheralArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //1.创建中心设备
    _center = [[CBCentralManager alloc]init];
    
    //2.利用中心设备扫描外设
    /*
        如果指定数组，代表只扫描指定设备
     option 指定额外的参数
     */
    [_center scanForPeripheralsWithServices:nil options:nil];
    
    _center.delegate = self;
    

}

#pragma mark - 中心设备代理
//发现外设代理方法
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //保存扫描到的外部设备
    if ([_peripheralArray containsObject:peripheral]) {
        NSLog(@"已经包含");
    }
    else
    {//不包含扫描到的设备
    [_peripheralArray addObject:peripheral];
        peripheral.delegate = self ;

        //连接外设
        [_center connectPeripheral:peripheral options:nil];
        
    }
}

//连接是否成功的代理
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //连接到了外设成功
    //扫描外设中的服务
    //指定数组，扫描数组里的外设
    [peripheral discoverServices:nil];
    
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //连接外设不成功
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}


#pragma mark - 外设代理方法
//外设发现服务代理方法 只要扫描到服务就会调用
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    //获取外设中所有的服务
    NSArray* service =  peripheral.services;
    for (CBService * serv in service) {
        //遍历服务，过滤服务
        if ([serv.UUID.UUIDString isEqualToString:@"什么UUID"]) {
            //找到需要的服务
            //从需要的服务中查找需要的特征
            
            //从这个外设的这个服务中扫描特征，array指定可以指定特征
            [peripheral discoverCharacteristics:nil forService:serv];
        }
        
    }
}

//发现服务的代理方法
//只要扫描到特征就会调用
//特征所属的外设，特征所属的服务，和错误
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    //拿到服务中所有的特征
    NSArray* characteristics = service.characteristics;
    //遍历特征
    for (CBCharacteristic* chara in characteristics) {
        if ([chara.UUID.UUIDString isEqualToString:@"某个特征码"]) {
            //使用某个服务的特征
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
