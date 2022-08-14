import 'dart:async';

import 'package:async/async.dart';
import 'package:hashed/datasource/remote/api/rates_repository.dart';

class GetRatesUseCase {
  final RatesRepository _ratesRepository = RatesRepository();

  Future<List<Result>> run() {
    final futures = [
      _ratesRepository.getFiatRates(),
    ];
    return Future.wait(futures);
  }
}
