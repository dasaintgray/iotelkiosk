import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GuestfoundView extends GetView {
  const GuestfoundView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GuestfoundView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GuestfoundView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
