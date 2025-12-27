class DhisDataValue {
  final String dataElement;
  final String value;
  final String? id;
  final String? event;

  DhisDataValue({
    this.id = '',
    this.event = '',
    required this.dataElement,
    required this.value,
  });

  factory DhisDataValue.fromJson(Map<String, dynamic> json) {
    String event = json['event'] ?? '';
    String dataElement = json['dataElement'] ?? '';
    return DhisDataValue(
      id: '${event}_$dataElement',
      event: event,
      dataElement: dataElement,
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'dataElement': dataElement,
    'value': value,
    'event': event,
    'id': id,
  };

  @override
  String toString() {
    return '< $dataElement $value >';
  }
}
