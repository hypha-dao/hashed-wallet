import 'package:hashed/datasource/remote/model/vote_model.dart';
import 'package:hive/hive.dart';

class VoteModelAdapter extends TypeAdapter<VoteModel> {
  @override
  final typeId = 3;

  @override
  VoteModel read(BinaryReader reader) {
    final fields = [];
    reader.readByte();
    fields.add(reader.readInt());
    reader.readByte();
    fields.add(reader.readBool());
    return VoteModel(amount: fields[0], isVoted: fields[1]);
  }

  @override
  void write(BinaryWriter writer, VoteModel obj) {
    writer.writeByte(0);
    writer.writeInt(obj.amount);
    writer.writeByte(1);
    writer.writeBool(obj.isVoted);
  }
}
