class Geo {
  final String lat;
  final String lng;

  const Geo({required this.lat, required this.lng});

  double? get latitude => double.tryParse(lat);
  double? get longitude => double.tryParse(lng);

  factory Geo.fromJson(Map<String, dynamic> json) =>
      Geo(lat: json['lat'] as String, lng: json['lng'] as String);

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}
