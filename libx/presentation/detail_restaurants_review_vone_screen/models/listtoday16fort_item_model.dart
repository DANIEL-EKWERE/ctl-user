// TODO Implement this library.
import '../../../core/app_export.dart';

/// This class is used in the [listtoday16fort_item_widget] screen.

// ignore_for_file: must_be_immutable
class Listtoday16fortItemModel {
  Listtoday16fortItemModel({
    this.today16forty,
    this.name,
    this.duration,
    this.whatcanisayitsf,
    this.likesCounter,
    this.id,
  }) {
    today16forty = today16forty ?? Rx(ImageConstant.imgImage);
    name = name ?? Rx("lbl_eleanor_summers".tr);
    duration = duration ?? Rx("lbl_today_16_40".tr);
    whatcanisayitsf = whatcanisayitsf ?? Rx("msg_what_can_i_say_it_s".tr);
    likesCounter = likesCounter ?? Rx("lbl_68_likes".tr);
    id = id ?? Rx("");
  }

  Rx<String>? today16forty;

  Rx<String>? name;

  Rx<String>? duration;

  Rx<String>? whatcanisayitsf;

  Rx<String>? likesCounter;

  Rx<String>? id;
}
