extension ShortString on String {
  /// The the first and last 7 characters of the string and ... in the middle
  /// perfect for substrate BIP39 style addresses.
  /// Fixed length of 17 characters
  ///
  String get shorter => length > 17 ? "${substring(0, 7)}...${substring(length - 7, length)}" : this;
}
