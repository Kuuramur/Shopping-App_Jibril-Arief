class LocationProvider {
  String? location;
  double? lat;
  double? lng;
  String? note;

  LocationProvider({
    required this.location,
    required this.lat,
    required this.lng,
    this.note,
  });

  LocationProvider.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['lat'] = lat;
    data['lng'] = lng;
    data['note'] = note;
    return data;
  }
}
