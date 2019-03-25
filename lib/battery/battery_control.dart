/// 电池电量控制器
class BatteryControl{

  QuantityListener listener;
  double value;

  BatteryControl(){
    value = 0;
  }

  /// 修改当前电量
  void quantity(double quantity){
    value =quantity;
    _notice();
  }

  /// 通知电池电量监听器
  void _notice(){
    listener(value);
  }

  /// 添加电池电量监听器
  void setListener(QuantityListener listener){
    listener=listener;
  }
  
}

/// 电池电量监听器
typedef QuantityListener(double quantity);