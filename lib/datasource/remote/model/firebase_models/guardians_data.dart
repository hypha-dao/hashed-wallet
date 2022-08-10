import 'package:hashed/datasource/local/models/account.dart';

class GuardiansData {
  final bool areGuardiansActive;
  final List<Account> guardians;

  GuardiansData(this.areGuardiansActive, this.guardians);
}
