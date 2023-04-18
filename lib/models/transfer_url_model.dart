import 'package:solana_web3/solana_web3.dart' as web3;

class TransferURLModel {
  late final web3.PublicKey recipient;
  late final double amount;
  late final web3.Keypair reference;
  late final String label;
  late final String? message;

  TransferURLModel({required this.recipient, required this.amount, required this.reference, required this.label, this.message});
}