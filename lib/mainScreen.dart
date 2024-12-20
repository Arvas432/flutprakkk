import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutprakkk/di.dart';
import 'package:flutprakkk/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'ip_bloc.dart';

class IPInfoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _ipController = TextEditingController();

    return BlocProvider(
      create: (_) => IpInfoBloc(),
      child: Padding(
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
                BlocBuilder<IpInfoBloc, IpInfoState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(Icons.search, color: Colors.blue),
                      onPressed: () {
                        final ip = _ipController.text.trim();
                        if (ip.isNotEmpty) {
                          context.read<IpInfoBloc>().add(FetchIpInfoEvent(ip));
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<IpInfoBloc, IpInfoState>(
                builder: (context, state) {
                  if (state is IpInfoLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is IpInfoLoaded) {
                    final ipInfo = state.ipInfo;
                    return Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: ipInfo.countryFlag,
                          fit: BoxFit.contain,
                          height: 150,
                          width: 225,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, size: 150, color: Colors.red),
                        ),
                        SizedBox(height: 10),
                        Text(
                          ipInfo.countryName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InformationTile(title: 'Country', value: ipInfo.countryName),
                        InformationTile(title: 'City', value: ipInfo.city),
                        InformationTile(title: 'ISP', value: ipInfo.isp),
                        InformationTile(title: 'IP Address', value: ipInfo.ip),
                        InformationTile(title: 'Latitude', value: ipInfo.latitude.toString()),
                        InformationTile(title: 'Longitude', value: ipInfo.longitude.toString()),
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
                        )
                      ],
                    );
                  } else if (state is IpInfoError) {
                    return Center(
                      child: Text(
                        'Error fetching IP info.',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return Center(
                    child: Text('Enter an IP address to fetch information.'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
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
