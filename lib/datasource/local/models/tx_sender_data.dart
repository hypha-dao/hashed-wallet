/// Used as sender object, or proxy object
/// proxy means "send on behalf of"
/// Example
/// sender == A and proxy == null means sender is A
/// sender == A and proxy == B will use B as sender of the transaction and A to sign
///
class TxSenderData {
  static const signerAddressPlaceholder = "signer";
  static const TxSenderData signer = TxSenderData(signerAddressPlaceholder);

  const TxSenderData(this.address);

  final String? address;

  factory TxSenderData.fromJson(Map<String, dynamic> json) => TxSenderData(
        json['address'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
      };

  factory TxSenderData.fromJsonOrPlaceholder(dynamic jsonOrPlaceholder) => jsonOrPlaceholder == signerAddressPlaceholder
      ? signer
      : TxSenderData.fromJson(jsonOrPlaceholder as Map<String, dynamic>);

  // either we return a proper JSON object or a signer placeholder
  dynamic toJsonOrPlaceholder() => this == signer
      ? signerAddressPlaceholder
      : {
          'address': address,
        };
}
