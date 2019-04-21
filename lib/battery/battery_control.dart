/// 电池电量控制器
class BatteryControl{

  QuantityListener listener;
  ChargingStateListener stateListener;
  double value;

  BatteryControl(){
    value = 0;
  }

  /// 修改当前电量
  void quantity(double quantity){
    assert(quantity<=1&&quantity>=0);
    value =quantity;
    _notice();
  }

  /// 通知电池电量监听器
  void _notice(){
    listener(value);
  }

  /// 设置充电状态
  void setState(ChargingState state){
    if(stateListener!=null){
      stateListener(state);
    }
  }

  /// 设置电池电量监听器
  void setListener(QuantityListener listener){
    this.listener=listener;
  }

  /// 设置充电状态监听器
  void setStateListener(ChargingStateListener listener){
    this.stateListener = listener;
  }
  
}

/// 电池电量监听器
typedef QuantityListener(double quantity);
/// 充电状态监听
typedef ChargingStateListener(ChargingState state);

enum ChargingState{
  charging,
  chargingEnd
}