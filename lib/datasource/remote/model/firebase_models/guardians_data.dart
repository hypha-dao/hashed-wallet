import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';

class GuardiansData {
  final bool areGuardiansActive;
  final List<GuardianModel> guardians;

  GuardiansData(this.areGuardiansActive, this.guardians);
}
