class Address {
  Address(
      {this.street,
      this.district,
      this.number,
      this.complement,
      this.zipCode,
      this.city,
      this.state,
      this.lat,
      this.long});

  String street;
  String district;
  String number;
  String complement;
  String zipCode;
  String city;
  String state;

  double lat;
  double long;

  @override
  String toString() {
    return 'Address{street: $street, district: $district, number: $number, '
        'complement: $complement, zipCode: $zipCode, city: $city, state:'
        ' $state, lat: $lat, long: $long}';
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'district': district,
      'number': number,
      'complement': complement,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'lat': lat,
      'long': long
    };
  }

  Address.fromMap(Map<String, dynamic> data) {
    street = data['street'] as String;
    district = data['district'] as String;
    number = data['number'] as String;
    complement = data['complement'] as String;
    zipCode = data['zipCode'] as String;
    city = data['city'] as String;
    state = data['state'] as String;
    lat = data['lat'] as double;
    long = data['long'] as double;
  }
}
