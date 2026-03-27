import 'package:ctluser/presentation/login_three_screen/models/category_model.dart';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../controller/login_three_controller.dart';
import '../models/login_three_one_item_model.dart';

// ignore_for_file: must_be_immutable
class LoginThreeOneItemWidget extends StatelessWidget {
  LoginThreeOneItemWidget(this.loginThreeOneItemModelObj, this.index, {Key? key}) : super(key: key);

  IndustryTypeItem loginThreeOneItemModelObj;
  int index;

  static const List<Color> _bgColors = [
    Color(0xFFE8F5E9), Color(0xFFFFF8E1), Color(0xFFE3F2FD),
    Color(0xFFFCE4EC), Color(0xFFF3E5F5), Color(0xFFE0F7FA),
    Color(0xFFFFF3E0), Color(0xFFE8EAF6),
  ];
  static const List<Color> _iconColors = [
    Color(0xFF2E7D32), Color(0xFFF57F17), Color(0xFF1565C0),
    Color(0xFFC62828), Color(0xFF6A1B9A), Color(0xFF00695C),
    Color(0xFFE65100), Color(0xFF283593),
  ];
  static const List<IconData> _icons = [
    Icons.restaurant, Icons.store, Icons.local_pharmacy,
    Icons.receipt_long, Icons.inventory_2, Icons.eco,
    Icons.event, Icons.more_horiz,
  ];

  @override
  Widget build(BuildContext context) {
    final colorIdx = index % _bgColors.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: _bgColors[colorIdx],
            borderRadius: BorderRadius.circular(14),
          ),
          child: loginThreeOneItemModelObj.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CustomImageView(imagePath: loginThreeOneItemModelObj.imageUrl!, fit: BoxFit.cover),
                )
              : Icon(_icons[colorIdx], color: _iconColors[colorIdx], size: 32),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 72,
          child: Text(
            loginThreeOneItemModelObj.name ?? "",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF333333)),
          ),
        ),
      ],
    );
  }
}
