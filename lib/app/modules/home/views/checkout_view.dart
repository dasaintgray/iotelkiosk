import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CheckoutView extends GetView {
  const CheckoutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckoutView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CheckoutView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
