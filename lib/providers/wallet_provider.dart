import 'package:flutter/foundation.dart';
import '../models/wallet_transaction.dart';

class WalletProvider extends ChangeNotifier {
  double _balance = 100.0;
  final List<WalletTransaction> _transactions = [];

  WalletProvider() {
    _initWelcomeBonus();
  }

  double get balance => _balance;
  List<WalletTransaction> get transactions => List.unmodifiable(_transactions);

  void _initWelcomeBonus() {
    _transactions.add(
      WalletTransaction(
        id: 'tx_welcome_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Welcome bonus',
        amount: 100.0,
        timestamp: DateTime.now(),
        type: TransactionType.credit,
      ),
    );
  }

  void addMoney(double amount) {
    if (amount <= 0) return;
    _balance += amount;
    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Added to Wallet',
        amount: amount,
        timestamp: DateTime.now(),
        type: TransactionType.credit,
      ),
    );
    notifyListeners();
  }

  bool deductMoney(double amount, String description) {
    if (amount <= 0 || _balance < amount) return false;
    _balance -= amount;
    _transactions.insert(
      0,
      WalletTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        title: description,
        amount: amount,
        timestamp: DateTime.now(),
        type: TransactionType.debit,
      ),
    );
    notifyListeners();
    return true;
  }
}
