import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetController extends GetxController{
  Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _connectivity.onConnectivityChanged.listen(Netstatus);
  }

  Netstatus(List <ConnectivityResult> cr){
    if(cr[0] == ConnectivityResult.none){
      Get.rawSnackbar(
        titleText: Container(
          width: double.infinity,
          height: MediaQuery.of(Get.context!).size.height * 0.9,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Icon(Icons.wifi_off, size: 120, color: Colors.black,)),
              Text('No internet Connection', style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500
              ),)
            ],
          ),
        ),
        messageText: Container(),
        isDismissible: false,
        duration: Duration(days: 1),
        backgroundColor: Colors.white
      );
    } else {
      if(Get.isSnackbarOpen){
        Get.closeCurrentSnackbar();
      }
    }
  }
}