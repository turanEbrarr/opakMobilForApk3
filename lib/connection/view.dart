import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:opak_mobil_v2/connection/getX_network_manager.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
} 

class _MyWidgetState extends State<MyWidget> {
final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Network Status'),
            GetBuilder(builder: (builder)=>Text('${_networkManager.connectionType}'))
          ],
        ),
      ),
    );
  }
}