class IpInfo {
  final String ip;
  final String hostname;
  final String continentCode;
  final String continentName;
  final String countryCode2;
  final String countryName;
  final String stateProv;
  final String city;
  final String zipcode;
  final double latitude;
  final double longitude;
  final String isp;
  final String organization;
  final String currencyCode;
  final String currencyName;
  final String timeZoneName;
  final String currentTime;
  final String countryFlag;

  IpInfo({
    required this.ip,
    required this.hostname,
    required this.continentCode,
    required this.continentName,
    required this.countryCode2,
    required this.countryName,
    required this.stateProv,
    required this.city,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.isp,
    required this.organization,
    required this.currencyCode,
    required this.currencyName,
    required this.timeZoneName,
    required this.currentTime,
    required this.countryFlag,
  });

  factory IpInfo.fromJson(Map<String, dynamic> json) {
    return IpInfo(
      ip: json['ip'] ?? 'Unknown IP',
      hostname: json['hostname'] ?? 'Unknown Hostname',
      continentCode: json['continent_code'] ?? 'N/A',
      continentName: json['continent_name'] ?? 'Unknown Continent',
      countryCode2: json['country_code2'] ?? 'N/A',
      countryName: json['country_name'] ?? 'Unknown Country',
      countryFlag: json['country_flag'] ?? 'assets/images/default_flag.png',
      stateProv: json['state_prov'] ?? 'Unknown State',
      city: json['city'] ?? 'Unknown City',
      zipcode: json['zipcode'] ?? 'N/A',
      latitude: double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      isp: json['isp'] ?? 'Unknown ISP',
      organization: json['organization'] ?? 'Unknown Organization',
      currencyCode: json['currency']?['code'] ?? 'N/A',
      currencyName: json['currency']?['name'] ?? 'Unknown Currency',
      timeZoneName: json['time_zone']?['name'] ?? 'Unknown Time Zone',
      currentTime: json['time_zone']?['current_time'] ?? 'N/A',
    );
  }
}
