import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solana_pay/views/home_screen.dart';

import '../models/transfer_url_model.dart';

class AcceptedScreen extends StatelessWidget {
  final TransferURLModel urlModel;
  final String transaction;
  const AcceptedScreen({Key? key, required this.urlModel, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: size.width * 0.8,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    padding: const EdgeInsets.all(24),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, widget) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.check, size: size.width * 0.2,),
                            SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: CircularProgressIndicator(
                                value: value,
                                strokeWidth: size.width * 0.04,
                                color: const Color.fromARGB(255, 11, 244, 168),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Transaction Accepted!!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    transaction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Wallet Address: ${urlModel.recipient.toBase58()}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Sol Amount: ${urlModel.amount.toString()}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Label: ${Uri.decodeFull(urlModel.label)}",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  if(urlModel.message != null) Column(
                    children: [
                      Text(
                        "Message: ${Uri.decodeFull(urlModel.message ?? "null")}",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Get.offAll(() => HomeScreen(), transition: Transition.fade, duration: const Duration(milliseconds: 400)),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black,
                      ),
                      child: const Text("Go Home", style: TextStyle(fontSize: 18, color: Colors.white),),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  AppBar appBar() {
    return AppBar(
      title: const Text("Solana Pay Qr Code Generator"),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color.fromARGB(255, 217, 34, 254),
                Color.fromARGB(255, 11, 244, 168),
              ]),
        ),
      ),
    ); //AppBar
  }
}
