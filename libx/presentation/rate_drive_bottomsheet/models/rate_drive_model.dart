import '../../../core/app_export.dart';
import 'chipviewlabel_item_model.dart';

/// This class defines the variables used in the [rate_drive_bottomsheet],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class RateDriveModel {
  Rx<List<ChipviewlabelItemModel>> chipviewlabelItemList = Rx([
    ChipviewlabelItemModel(labelSix: "lbl_good_service".tr.obs),
    ChipviewlabelItemModel(labelSix: "lbl_on_time".tr.obs),
    ChipviewlabelItemModel(labelSix: "lbl_clean".tr.obs),
    ChipviewlabelItemModel(labelSix: "lbl_carefull".tr.obs),
    ChipviewlabelItemModel(labelSix: "lbl_work_hard".tr.obs),
    ChipviewlabelItemModel(labelSix: "lbl_polite".tr.obs),
  ]);
}
