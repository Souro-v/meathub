import 'package:meathub/models/refund_method_model.dart';

class DummyIssueOptions {
  DummyIssueOptions._();

  static const List<String> issueTypes = [
    'Wrong item received',
    'Damaged item',
    'Missing item',
    'Poor quality',
    'Other',
  ];

  static const List<String> refundReasons = [
    'Wrong item received',
    'Damaged item',
    'Missing item',
    'Order cancelled',
    'Other',
  ];

  static const List<RefundMethodModel> refundMethods = [
    RefundMethodModel(
      id: 'original',
      title: 'Original payment method',
      subtitle: 'Refund to your original payment source',
    ),
    RefundMethodModel(
      id: 'wallet',
      title: 'MeatHub Wallet',
      subtitle: 'Refund to MeatHub Wallet (Faster)',
    ),
  ];
}
