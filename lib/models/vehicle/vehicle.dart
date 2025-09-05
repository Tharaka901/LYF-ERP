class Vehicle {
  final int? vehicleId;
  final String? vehicleRegId;
  final String? registrationNumber;

  Vehicle({this.vehicleId, this.vehicleRegId, this.registrationNumber});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleId: json['vehicleId'],
      vehicleRegId: json['vehicleRegId'],
      registrationNumber: json['registrationNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'vehicleRegId': vehicleRegId,
      'registrationNumber': registrationNumber,
    };
  }
}
