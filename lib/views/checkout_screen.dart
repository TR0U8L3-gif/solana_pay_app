import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_solana_pay/controllers/solana_controller.dart';

import '../models/transfer_url_model.dart';

class CheckoutScreen extends StatelessWidget {
  final TransferURLModel urlModel;
  final String url;

  CheckoutScreen({Key? key, required this.urlModel, required this.url})
      : super(key: key);
  final SolanaController solanaController = Get.find();

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
                  PrettyQr(
                    image: const AssetImage('assets/images/solana_pay_qr.png'),
                    size: size.width * 0.8,
                    data: url,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    roundEdges: true,
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
                  if (urlModel.message != null)
                    Column(
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
                    onTap: () {
                      Get.back(closeOverlays: true);
                      solanaController.closeTimer();
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black,
                      ),
                      child: const Text(
                        "Go Back",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
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
