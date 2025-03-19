import 'package:dabbawala/utils/constants/used_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/dabbawala_model.dart';

class DabbawalaController extends GetxController {
  var isLoading = false.obs;
  var dabbawalas = <Dabbawala>[].obs;
  var filteredDabbawalas = <Dabbawala>[].obs;  // Filtered list for UI
  var currentPage = 1;
  final int limit = 5;

  @override
  void onInit() {
    super.onInit();
    fetchDabbawalas();
  }

  Future<void> fetchDabbawalas() async {
    try {
      isLoading(true);
      final response = await fetchDabbawalasApi(currentPage, limit);
      dabbawalas.addAll(response.users); // Store the full list
      filteredDabbawalas.assignAll(dabbawalas); // Initially show all
      currentPage++;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<DabbawalaResponse> fetchDabbawalasApi(int page, int limit) async {
    final response = await http.get(
      Uri.parse('${UsedConstants.baseUrl}/customer/dabbewala'),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return DabbawalaResponse.fromJson(response.body);
    } else {
      throw Exception('Failed to load dabbawalas');
    }
  }

  // 🔍 Filter Logic (Updated)
  void filterDabbawalas(String query) {
    if (query.isEmpty) {
      filteredDabbawalas.assignAll(dabbawalas);
    } else {
      filteredDabbawalas.value = dabbawalas
          .where((dabbawala) =>
              dabbawala.name.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    }
  }
}
