import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum { Home, Browse, Order, Support, Profile }

// ignore_for_file: must_be_immutable
class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({Key? key, this.onChanged}) : super(key: key);

  RxInt selectedIndex = 0.obs;
  Function(BottomBarEnum)? onChanged;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: "Home", type: BottomBarEnum.Home),
    _NavItem(icon: Icons.search, activeIcon: Icons.search, label: "Search", type: BottomBarEnum.Browse),
    _NavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: "Orders", type: BottomBarEnum.Order),
    _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: "Support", type: BottomBarEnum.Support),
    _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: "Profile", type: BottomBarEnum.Profile),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Obx(() => Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = selectedIndex.value == index;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    selectedIndex.value = index;
                    onChanged?.call(item.type);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      index == 2
                          ? Stack(clipBehavior: Clip.none, children: [
                              Icon(selected ? item.activeIcon : item.icon, size: 24, color: selected ? const Color(0xFF1B5E20) : const Color(0xFF888888)),
                              Positioned(
                                top: -4, right: -6,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(color: Color(0xFF1B5E20), shape: BoxShape.circle),
                                  child: const Text("2", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ])
                          : Icon(selected ? item.activeIcon : item.icon, size: 24, color: selected ? const Color(0xFF1B5E20) : const Color(0xFF888888)),
                      const SizedBox(height: 3),
                      Text(item.label, style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? const Color(0xFF1B5E20) : const Color(0xFF888888))),
                    ],
                  ),
                ),
              );
            }),
          )),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final BottomBarEnum type;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.type});
}

class BottomMenuModel {
  final String icon;
  final String activeIcon;
  final String title;
  final BottomBarEnum type;
  bool isCircle;
  BottomMenuModel({required this.icon, required this.activeIcon, required this.title, required this.type, this.isCircle = false});
}
