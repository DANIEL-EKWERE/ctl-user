// Redesigned: Chewdeck-style Order Tracking Screen
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/your_orders_ongoing_controller.dart';
import 'models/timelineclose_item_model.dart';

// ignore_for_file: must_be_immutable
YourOrdersOngoingController controller = Get.put(YourOrdersOngoingController());

class YourOrdersOngoingScreen extends StatefulWidget {
  const YourOrdersOngoingScreen({Key? key}) : super(key: key);
  @override
  State<YourOrdersOngoingScreen> createState() => _YourOrdersOngoingScreenState();
}

class _YourOrdersOngoingScreenState extends State<YourOrdersOngoingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B))),
        title: const Text("Track Order", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map placeholder
            Container(
              height: 240,
              color: const Color(0xFFE8F5E9),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.map_outlined, size: 80, color: Color(0xFF1B5E20)),
                  Positioned(
                    bottom: 16, left: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                      child: Row(children: [
                        Container(width: 36, height: 36, decoration: BoxDecoration(color: const Color(0xFF1B5E20), shape: BoxShape.circle),
                          child: const Icon(Icons.delivery_dining, color: Colors.white, size: 20)),
                        const SizedBox(width: 10),
                        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Your rider is on the way", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                          Text("Arriving in 15-20 mins", style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
                        ])),
                        const Icon(Icons.phone_outlined, color: Color(0xFF1B5E20), size: 22),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            // Order status timeline
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order Status", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                  const SizedBox(height: 20),
                  _buildTimelineStep(Icons.check_circle, "Order Confirmed", "Your order has been received", true, true),
                  _buildTimelineStep(Icons.restaurant, "Preparing Order", "Restaurant is preparing your food", true, true),
                  _buildTimelineStep(Icons.delivery_dining, "Out for Delivery", "Rider is on the way to you", true, false),
                  _buildTimelineStep(Icons.home_outlined, "Delivered", "Order delivered to your door", false, false),
                ],
              ),
            ),
            // Order summary card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Order Summary", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                  const Divider(height: 20, color: Color(0xFFF0F0F0)),
                  _buildSummaryRow("Subtotal", "₦6,000"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Delivery Fee", "₦400"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Service Fee", "₦600"),
                  const Divider(height: 20, color: Color(0xFFF0F0F0)),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                    Text("Total", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1B1B1B))),
                    Text("₦7,000", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1B1B1B))),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(IconData icon, String title, String subtitle, bool done, bool current) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(
                color: done ? const Color(0xFF1B5E20) : current ? const Color(0xFFE8F5E9) : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
                border: current && !done ? Border.all(color: const Color(0xFF1B5E20), width: 2) : null,
              ),
              child: Icon(icon, size: 16, color: done ? Colors.white : current ? const Color(0xFF1B5E20) : const Color(0xFFAAAAAA)),
            ),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
              color: done || current ? const Color(0xFF1B1B1B) : const Color(0xFFAAAAAA))),
            Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ])),
          if (done) const Icon(Icons.check, size: 16, color: Color(0xFF1B5E20)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1B1B1B))),
    ]);
  }
}
