import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:solana/solana.dart' as solana;
import 'package:solana/solana_pay.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/rpc_models/account_info.dart';

import '../models/transfer_url_model.dart';
import '../views/accepted_screen.dart';
import '../views/checkout_screen.dart';

class SolanaController extends GetxController {
  final Rx<bool> _isGenerating = Rx(false);
  late final web3.Cluster cluster;
  late final web3.Connection connection;
  late final solana.SolanaClient client;
  Timer? timer;

  bool get isGenerating => _isGenerating.value;

  @override
  void onInit() {
    super.onInit();
    cluster = web3.Cluster.devnet;
    connection = web3.Connection(cluster);
    debugPrint("client: ${cluster.uri()}  ${cluster.toWebSocket().uri()}");
    client = solana.SolanaClient(
        rpcUrl: cluster.uri(), websocketUrl: cluster.toWebSocket().uri());
  }

  @override
  void onClose() {
    super.onClose();
    closeTimer();
  }

  Future<void> createQr(String publicKey, String amount, String label,
      [String? message]) async {
    if (_isGenerating.value) return;

    _isGenerating.value = true;

    // check wallet address
    if (publicKey.isEmpty || !solana.isValidAddress(publicKey)) {
      Get.snackbar(
          "Solana Wallet Address is incorrect",
          publicKey.isEmpty
              ? "publicKey is empty"
              : "publicKey: $publicKey is incorrect");
      _isGenerating.value = false;
      return;
    }

    web3.PublicKey recipient = web3.PublicKey.fromString(publicKey);

    AccountInfo<Object>? accountInfo =
        await connection.getAccountInfo(recipient);

    if (accountInfo == null) {
      Get.snackbar("Solana Wallet Address is incorrect",
          "Account: $publicKey do not exist");
      _isGenerating.value = false;
      return;
    }

    debugPrint("${accountInfo.toJson()}");

    // check sol amount
    double sol;

    if (amount.isNotEmpty && double.tryParse(amount) != null) {
      sol = double.parse(amount);
    } else {
      Get.snackbar("Sol Amount is incorrect",
          amount.isNotEmpty ? "Wrong format: $amount" : "Field is empty");
      _isGenerating.value = false;
      return;
    }

    debugPrint("Sol: $amount");

    // check label
    label = label.trimLeft().trimRight();

    if (label.isEmpty) {
      Get.snackbar("Label is incorrect", "Field is empty");
      _isGenerating.value = false;
      return;
    }
    if (label.length > 24) {
      Get.snackbar(
          "Label is incorrect", "Label length is greater than 24 characters");
      _isGenerating.value = false;
      return;
    }

    label = Uri.encodeFull(label);
    debugPrint("label: $label");

    // check message
    bool isMessage = true;

    if (message == null) {
      isMessage = false;
    } else {
      message = message.trimRight().trimLeft();
      if (message.isEmpty) isMessage = false;
      if (message.length > 24) {
        Get.snackbar("Message is incorrect",
            "Message length is greater than 24 characters");
        _isGenerating.value = false;
        return;
      }
      message = Uri.encodeFull(message);
    }
    debugPrint("message: $message");

    // generate reference
    web3.Keypair reference = web3.Keypair.generateSync();

    // generate url

    String url;
    TransferURLModel transferModel;

    if (!isMessage) {
      url = 'solana:${recipient.toBase58()}'
          '?amount=$sol'
          '&reference=${reference.publicKey.toBase58()}'
          '&label=$label';
      transferModel = TransferURLModel(
          recipient: recipient,
          amount: sol,
          reference: reference,
          label: label);
    } else {
      url = 'solana:${recipient.toBase58()}'
          '?amount=$sol'
          '&reference=${reference.publicKey.toBase58()}'
          '&label=$label'
          '&message=$message';
      transferModel = TransferURLModel(
          recipient: recipient,
          amount: sol,
          reference: reference,
          label: label,
          message: message);
    }

    debugPrint(url);

    timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      String? found = await client.findSolanaPayTransaction(
        reference: solana.Ed25519HDPublicKey.fromBase58(
            reference.publicKey.toBase58()),
        commitment: solana.Commitment.confirmed,
      );
      if (found != null) {
        await client.validateSolanaPayTransaction(
          signature: found,
          recipient: solana.Ed25519HDPublicKey.fromBase58(recipient.toBase58()),
          // ignore: avoid-non-null-assertion, cannot be null here
          amount: SolanaPayRequest.parse(url).amount!,
          commitment: solana.Commitment.confirmed,
        ).then((transaction) {
          debugPrint("Transaction accepted! $transaction");
          closeTimer();
          Get.to(() => AcceptedScreen(
                    urlModel: transferModel,
                    transaction: found,
                  ),
              transition: Transition.fade,
              duration: const Duration(milliseconds: 400));
        });
        debugPrint("Transaction found Signature: $found");
      } else {
        debugPrint("Can not find transaction");
      }
    });

    // go to solana pay checkout
    Get.to(
        () => CheckoutScreen(
              urlModel: transferModel,
              url: url,
            ),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 400));
    Future.delayed(const Duration(milliseconds: 600)).then((value) => _isGenerating.value = false);
  }

  closeTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }
}
