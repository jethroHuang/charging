/// 电池电量控制器
class BatteryControl{

  List<QuantityListener> listeners;
  double value;

  BatteryControl(){
    listeners =List();
    value = 0;
  }

  /// 修改当前电量
  void quantity(double quantity){
    value =quantity;
    _notice();
  }

  /// 通知电池电量监听器
  void _notice(){
    listeners.forEach((listener){
      listener(value);
    });
  }

  /// 添加电池电量监听器
  void addListener(QuantityListener listener){
    listeners.add(listener);
  }
  
}

/// 电池电量监听器
typedef QuantityListener(double quantity);