import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:website_datatables/app/data/models/fake_data_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Table View',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.withOpacity(0.1),
        shadowColor: Colors.transparent,
      ),
      body: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
          child: controller.isLoading.isTrue
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(color: Colors.blueAccent, size: 50),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Server Side',
                      style: TextStyle(fontSize: 4.sp),
                    ),
                    const Divider().marginOnly(bottom: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('show'),
                            Container(
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                                border: Border.all(color: Colors.grey, width: 1.0),
                              ),
                              child: DropdownButton<int>(
                                value: controller.rowsPerPage.value,
                                underline: Container(),
                                onChanged: (newValue) {
                                  controller.rowsPerPage.value = newValue!;
                                  controller.rowsPerPageData.value = newValue;
                                  controller.currentPage.value = 2;
                                },
                                padding: EdgeInsets.only(left: 1.w),
                                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                                items: List.generate(5, (index) {
                                  return DropdownMenuItem<int>(
                                    value: index + 6,
                                    child: Text((index + 6).toString()),
                                  );
                                }),
                              ),
                            ).marginSymmetric(horizontal: 1.w),
                            const Text('entries'),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Search'),
                            Container(
                              height: 35,
                              width: 30.w,
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.r)),
                                border: Border.all(color: Colors.grey, width: 1.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: TextField(
                                  controller: controller.searchController,
                                  onChanged: (value) {
                                    controller.searchControllerString.value = value;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ).marginOnly(left: 1.w),
                          ],
                        ),
                      ],
                    ).marginOnly(bottom: 10.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.totalPages.value,
                        itemBuilder: (context, index) {
                          if (index == controller.totalPages.value - 1) {
                            return Obx(
                              () => Column(
                                children: [
                                  SizedBox(
                                    width: 270.w,
                                    child: _createDataTable(controller.rangeRows).marginOnly(bottom: 20),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          controller.buttonPressed.value = 'back';
                                          if (controller.currentPage.value > 1) {
                                            controller.fetchData(controller.currentPage.value - 1);
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 10.r,
                                          backgroundColor: Colors.purple.withOpacity(0.1),
                                          child: Icon(
                                            size: 7.r,
                                            Icons.arrow_back_ios_outlined,
                                            color: Colors.purple.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      Container().marginSymmetric(horizontal: 1.w),
                                      GestureDetector(
                                        onTap: () {
                                          if (controller.currentPage.value + 1 <= controller.lastPageNum) {
                                            controller.buttonPressed.value = 'forward';
                                            controller.fetchData(controller.currentPage.value + 1);
                                          }
                                        },
                                        child: CircleAvatar(
                                          radius: 10.r,
                                          backgroundColor: Colors.purple.withOpacity(0.1),
                                          child: Icon(
                                            size: 7.r,
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.purple.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  DataTable _createDataTable(List<FakeTitleBodyData> rangeRows) {
    return DataTable(
      columns: _createColumns(),
      rows: _createRows(rangeRows),
      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.purple.withOpacity(0.1)),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(
        label: Text('ID'),
      ),
      const DataColumn(
        label: Text('Title'),
      ),
      const DataColumn(
        label: Text('Body'),
      ),
    ];
  }

  List<DataRow> _createRows(List<FakeTitleBodyData> rangeRows) {
    return rangeRows
        .map(
          (e) => DataRow(
            cells: [
              DataCell(Text('# ${e.id}')),
              DataCell(Text(e.title)),
              DataCell(Text(e.body)),
            ],
          ),
        )
        .toList();
  }
}
