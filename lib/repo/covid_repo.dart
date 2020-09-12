import 'dart:convert' as convert;

import 'package:flutter_future_builder_sample/constants/constants.dart';
import 'package:flutter_future_builder_sample/models/summary_data.dart';
import 'package:http/http.dart' as http;

abstract class COVIDDataRepository {
  Future<SummaryResponse> getSummary();
}

class COVIDDataRepositoryImpl implements COVIDDataRepository {
  @override
  Future<SummaryResponse> getSummary() async {
    final response = await http.get('$BASE_URL/summary');
    var summaryResponse;
    if (response.statusCode == 200) {
      var summaryResponseJson = convert.jsonDecode(response.body);
      summaryResponse = SummaryResponse.fromJson(summaryResponseJson);
      return summaryResponse;
    }
    else{
      throw Exception("Failure Response");
    }
  }
}
