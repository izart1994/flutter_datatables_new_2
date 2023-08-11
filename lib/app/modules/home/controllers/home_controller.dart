import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:website_datatables/app/data/models/fake_data_model.dart';
import 'package:website_datatables/app/data/repo/fake_data_repo.dart';

class HomeController extends GetxController {
  FakeDataRepository fakeDataRepo = FakeDataRepository();
  RxList<FakeTitleBodyData> fakeDataList = <FakeTitleBodyData>[].obs;
  RxList<FakeTitleBodyData> filteredFakeDataList = <FakeTitleBodyData>[].obs;

  TextEditingController searchController = TextEditingController();
  RxString searchControllerString = ''.obs;

  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt rowsPerPage = 10.obs;
  RxInt rowsPerPageData = 10.obs;
  RxString buttonPressed = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getFakeData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ///// get data from the fake data repo and change it to selected variables
  Future<void> getFakeData() async {
    isLoading(true);
    try {
      final response = await fakeDataRepo.getFakeTitleBodyData();
      if (response.data is List) {
        fakeDataList.value = (response.data as List).map((data) => FakeTitleBodyData.fromJson(data)).toList();
        filteredFakeDataList.addAll(fakeDataList);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
      rethrow;
    }
  }

  // Simulated data fetching function
  Future<void> fetchData(int page) async {
    currentPage.value = page;
    if (page == 1) {
      if (buttonPressed.value == 'back') {
        rowsPerPageData.value -= rowsPerPage.value;
      } else {
        rowsPerPageData.value = int.parse('${currentPage.value.toString()}0');
      }
    } else {
      if (rowsPerPage.value < 10) {
        if (buttonPressed.value == 'back') {
          rowsPerPageData.value -= rowsPerPage.value;
        } else {
          rowsPerPageData.value += page == 2 ? 0 : rowsPerPage.value;
        }
        if (rowsPerPageData.value < 10) {
          rowsPerPageData.value = rowsPerPage.value;
        }
      } else {
        rowsPerPageData.value = int.parse('${currentPage.value.toString()}0') - 10;
      }
    }
  }

  List<FakeTitleBodyData> get rangeRows {
    if (searchControllerString.value != '') {
      if (currentPage.value == 1) {
        return filteredFakeDataList.sublist(0, rowsPerPageData.value == 0 ? rowsPerPage.value : rowsPerPageData.value).where((e) => e.title.contains(searchControllerString.value)).toList();
      } else {
        return filteredFakeDataList.sublist(rowsPerPageData.value, rowsPerPage.value + rowsPerPageData.value).where((e) => e.title.contains(searchControllerString.value)).toList();
      }
    } else {
      if (currentPage.value == 1) {
        if (buttonPressed.value == 'back') {
          return filteredFakeDataList.sublist(0, rowsPerPage.value);
        } else {
          return filteredFakeDataList.sublist(0, rowsPerPageData.value);
        }
      } else {
        if (lastPageNum != currentPage.value) {
          return filteredFakeDataList.sublist(rowsPerPageData.value, rowsPerPage.value + rowsPerPageData.value);
        } else {
          if (rowsPerPage.value != 10) {
            RxInt remainingNum = 0.obs;
            if (rowsPerPage.value % 2 == 0) {
              remainingNum.value = 4;
            } else {
              remainingNum.value = rowsPerPage.value == 9 ? 1 : 2;
            }
            return filteredFakeDataList.sublist(rowsPerPageData.value, rowsPerPageData.value + remainingNum.value);
          } else {
            return filteredFakeDataList.sublist(rowsPerPageData.value, rowsPerPage.value + rowsPerPageData.value);
          }
        }
      }
    }
  }

  int get lastPageNum {
    double division = fakeDataList.length / rowsPerPage.value;
    return division.ceil().toInt();
  }

  void clearSearch() {
    searchController.clear();
    filteredFakeDataList.clear();
    filteredFakeDataList.addAll(fakeDataList);
  }
}
