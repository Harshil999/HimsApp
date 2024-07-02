import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:venus/app/app_common_widgets/common_text.dart';
import 'package:venus/app/app_common_widgets/common_textform_field.dart';
import 'package:venus/app/app_common_widgets/sizer_constant.dart';
import 'package:venus/app/core/constant/asset_constant.dart';
import 'package:venus/app/core/them/const_color.dart';
import 'package:venus/app/modules/patientlist/views/widgets/listview_widget.dart';

import '../../../../main.dart';
import '../controllers/patientlist_controller.dart';

class PatientlistView extends GetView<PatientlistController> {
  const PatientlistView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(PatientlistController());
    return GetBuilder<PatientlistController>(builder: (controller) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: AppText(
            text: 'Patients',
            fontSize: Sizes.px22,
            fontColor: ConstColor.headingTexColor,
            fontWeight: FontWeight.w800,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          excludeHeaderSemantics: false,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: Colors.white,
        // drawer: const MyDrawer(),
        body: Stack(
          alignment: Alignment.bottomCenter,
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                SizedBox(
                  height: Sizes.crossLength * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: Sizes.crossLength * 0.020,
                    right: Sizes.crossLength * 0.020,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.searchController,
                          onTap: () {
                            controller.showShortButton = false;
                            controller.update();
                          },
                          onChanged: (text) {
                            controller.getFilterData(
                                searchPrefix: text, isLoader: false);
                          },
                          textInputAction: TextInputAction.done,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 30),
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                            // Future.delayed(const Duration(milliseconds: 300));
                            controller.showShortButton = true;
                            controller.update();
                          },
                          onFieldSubmitted: (v) {
                            if (controller.searchController.text
                                .trim()
                                .isNotEmpty) {
                              controller.getFilterData(
                                  searchPrefix:
                                      controller.searchController.text.trim(),
                                  isLoader: false);
                            }
                            Future.delayed(const Duration(milliseconds: 800));
                            controller.showShortButton = true;
                            controller.update();
                          },
                          suffixIcon: controller.searchController.text
                                  .trim()
                                  .isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    controller.searchController.clear();
                                    controller.getFilterData(isLoader: false);
                                  },
                                  child: const Icon(Icons.cancel_outlined))
                              : const SizedBox(),
                          prefixIcon: SvgPicture.asset(
                            ConstAsset.searchSvg,
                            height: Sizes.crossLength * 0.020,
                            width: Sizes.crossLength * 0.020,
                          ),
                          hintText: 'Search Patient',
                        ),
                      ),
                      SizedBox(
                        width: Sizes.crossLength * 0.015,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.registerFiltterBottomSheet();
                        },
                        child: Container(
                          height: Sizes.crossLength * 0.050,
                          width: Sizes.crossLength * 0.050,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1, color: ConstColor.borderColor),
                          ),
                          child: Center(
                            child: SvgPicture.asset(ConstAsset.filterSvg),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Sizes.crossLength * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: getDynamicHeight(size: 0.020),
                          width: getDynamicHeight(size: 0.020),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ConstColor.buttonColor),
                        ),
                        SizedBox(
                          width: getDynamicHeight(size: 0.010),
                        ),
                        AppText(
                          text: 'Admitted Patients',
                          fontSize: Sizes.px14,
                          fontColor: ConstColor.black6B6B6B,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: getDynamicHeight(size: 0.025),
                    ),
                    Row(
                      children: [
                        Container(
                          height: getDynamicHeight(size: 0.020),
                          width: getDynamicHeight(size: 0.020),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ConstColor.refferedColor),
                        ),
                        SizedBox(
                          width: getDynamicHeight(size: 0.010),
                        ),
                        AppText(
                          text: 'Referred Patients',
                          fontSize: Sizes.px14,
                          fontColor: ConstColor.black6B6B6B,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(
                  child: controller.filterPatientList != null
                      ? controller.filterPatientList!.isEmpty
                          ? Center(
                              child: AppText(
                                text: 'No records found',
                                fontSize: Sizes.px16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: controller.filterPatientList != null &&
                                      controller.filterPatientList!.length < 3
                                  ? const NeverScrollableScrollPhysics()
                                  : const BouncingScrollPhysics(),
                              controller: controller.patientScrollController,
                              padding: EdgeInsets.only(
                                  bottom: hideBottomBar.value
                                      ? Sizes.crossLength * 0.020
                                      : Sizes.crossLength * 0.120),
                              itemCount: controller.filterPatientList!.length,
                              itemBuilder: (context, i) {
                                return PatientList(
                                  patientData: controller.filterPatientList![i],
                                );
                              },
                            )
                      : controller.patientList.isEmpty
                          ? Center(
                              child: AppText(
                                text: 'No records found',
                                fontSize: Sizes.px16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : ListView.builder(
                              controller: controller.patientScrollController,
                              physics: controller.patientList.isNotEmpty &&
                                      controller.filterPatientList!.length < 3
                                  ? const NeverScrollableScrollPhysics()
                                  : const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(
                                  bottom: hideBottomBar.value
                                      ? Sizes.crossLength * 0.020
                                      : Sizes.crossLength * 0.120),
                              itemCount: controller.patientList.length,
                              itemBuilder: (context, i) {
                                return PatientList(
                                  patientData: controller.patientList[i],
                                );
                              },
                            ),
                ),
              ],
            ),
            controller.showShortButton && !hideBottomBar.value
                ? Padding(
                    padding:
                        EdgeInsets.only(bottom: hideBottomBar.value ? 20 : 60),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 45,
                        width: 150,
                        child: OutlinedButton.icon(
                          icon: SvgPicture.asset(
                              "assets/images/svg/sortFilter.svg"),
                          label: AppText(
                            text: "Sort By",
                            fontSize: Sizes.px14,
                            fontWeight: FontWeight.w600,
                            fontColor: ConstColor.black5E5E5E,
                          ),
                          onPressed: () {
                            controller.sortBy();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: ConstColor.whiteColor,
                            side: const BorderSide(
                                width: 1.0, color: ConstColor.buttonColor),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      );
    });
  }
}

methodname(String floor) {
  switch (floor) {
    case '0':
      return 'Ground';
    case '1':
      return 'First';
    case '2':
      return 'Second';
    case '3':
      return 'Third';
    case '4':
      return 'Fourth';
    default:
      return 'Waiting Area';
  }
}
