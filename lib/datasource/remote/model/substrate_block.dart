import 'package:hashed/datasource/remote/model/substrate_block_header.dart';

class SubstrateBlock {
  /// Note: block has a few more fields but we only use header
  final SubstrateBlockHeader header;

  SubstrateBlock({required this.header});

  factory SubstrateBlock.fromJson(Map<String, dynamic> json) {
    return SubstrateBlock(header: SubstrateBlockHeader.fromJson(json["header"]));
  }
}
