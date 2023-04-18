import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solana_pay/controllers/solana_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final SolanaController solanaController = Get.put(SolanaController());
  final TextEditingController publicKey = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController label = TextEditingController();
  final TextEditingController message = TextEditingController();

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
                  Image.asset("assets/images/solana_pay_dark.png"),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Wallet Address",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: size.width,
                      height: 48,
                      child: TextFormFieldWidget(
                        controller: publicKey,
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "SOL Amount",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: size.width,
                      height: 48,
                      child: TextFormFieldWidget(
                        controller: amount,
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Label",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: size.width,
                      height: 48,
                      child: TextFormFieldWidget(
                        controller: label,
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Message",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: size.width,
                      height: 48,
                      child: TextFormFieldWidget(
                        controller: message,
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () => solanaController.createQr(publicKey.text, amount.text, label.text, message.text),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black,
                      ),
                      child: Obx(() {
                          if(solanaController.isGenerating){
                            return const Padding(padding: EdgeInsets.all(4), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),);
                          }
                          else{
                            return const Text("Generate Qr Code", style: TextStyle(fontSize: 18, color: Colors.white),);
                          }
                        }
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

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const TextFormFieldWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      ),
    );
  }
}
