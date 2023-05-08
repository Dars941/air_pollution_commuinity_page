import 'package:flutter/material.dart';

import 'comm_posts_page.dart';
import 'weather_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Community Post User'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommunityPosts(isAdmin: false),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Community Post Admin'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommunityPosts(isAdmin: true),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Weather'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WeatherPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
