enum TransactionType { credit, debit }

class WalletTransaction {
  final String id;
  final String title;
  final double amount;
  final DateTime timestamp;
  final TransactionType type;

  const WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.timestamp,
    required this.type,
  });

  bool get isCredit => type == TransactionType.credit;
}
