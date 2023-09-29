import 'package:get/get.dart';
import 'package:opak_mobil_v2/connection/getX_network_manager.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut<GetXNetworkManager>(() => GetXNetworkManager());
  }

}