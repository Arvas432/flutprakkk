import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import 'IpFindRepository.dart';

class IPInfoLayout extends StatefulWidget {
  const IPInfoLayout({super.key});

  @override
  _IPInfoLayoutState createState() => _IPInfoLayoutState();
}

class _IPInfoLayoutState extends State<IPInfoLayout> with AutomaticKeepAliveClientMixin {
  String _currentFlag = 'assets/images/flag.png';
  String _countryName = 'Country';
  String _cityName = "City";
  String _ipAddr = "IP Address";
  String _provider = "ISP";
  String _latitude = 'Latitude';
  String _longitude = 'Longitude';

  final TextEditingController _ipController = TextEditingController();
  bool _isLoading = false;

  Future<void> _fetchIpInfo() async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = '455322ed084f4554b56ceebebcf907ae';
    final ipAddress = _ipController.text;

    final ipInfo = await fetchIpInfoWithAsyncAwait(ipAddress, apiKey);
    //final ipInfo = await fetchIpInfoWithFuture(ipAddress, apiKey);
    print(ipInfo?.countryFlag);
    if (ipInfo != null) {
      setState(() {
        _currentFlag = ipInfo.countryFlag;
        _countryName = ipInfo.countryName;
        _cityName = ipInfo.city;
        _ipAddr = ipInfo.ip;
        _provider = ipInfo.isp;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Color(0xFFE6E8EB),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _ipController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter IP Address',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.search, color: Colors.blue),
                onPressed: _isLoading ? null : _fetchIpInfo,
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/world_map.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : CachedNetworkImage(
                        imageUrl: _currentFlag,
                        fit: BoxFit.contain,
                        height: 150,
                        width: 225,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: Color(0x3B9EBF),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 150,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _countryName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          InformationTile(title: 'Country', value: _countryName),
          InformationTile(title: 'City', value: _cityName),
          InformationTile(title: 'ISP', value: _provider),
          InformationTile(title: 'IP Address', value: _ipAddr),
          InformationTile(title: 'Latitude', value: _latitude),
          InformationTile(title: 'Longitude', value: _longitude),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  iconPath: 'assets/icons/show_on_map_ic.svg',
                  label: 'Show\non Map',
                  onPressed: () {
                    context.go('/main/mapsHost');
                  },
                ),
              ),
              SizedBox(width: 10), // Space between buttons
              Expanded(
                child: ActionButton(
                  iconPath: 'assets/icons/more_data_ic.svg',
                  label: 'More\nInfo',
                  onPressed: () {
                    context.go('/main/additionalInfo');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class InformationTile extends StatelessWidget {
  final String title;
  final String value;

  InformationTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFFE6E8EB),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16)),
            Text(value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onPressed;

  ActionButton(
      {required this.iconPath, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD4D4D4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(width: 24),
            SvgPicture.asset(
              iconPath,
              height: 50,
              width: 50,
            )
          ],
        ),
      ),
    );
  }
}
