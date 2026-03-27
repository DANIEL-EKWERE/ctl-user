import '../../core/app_export.dart';
import 'controller/review_controller.dart';
import '../reviewscreenshop/reviewShopScreen.dart';
import 'package:flutter/material.dart';

ReviewController controller = Get.put(ReviewController());

class Reviewscreen extends StatefulWidget {
  const Reviewscreen({super.key});

  @override
  State<Reviewscreen> createState() => _ReviewscreenState();
}

class _ReviewscreenState extends State<Reviewscreen> {
  List<String> tags = [
    'Excellence',
    'Good Service',
    'On Time',
    'Clean',
    'Careful',
    'Work Hard',
    'polite',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 800.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(39),
        ),
      ),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Rate Driver'),
          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 35),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(imagePath: ImageConstant.imgEllipse8),
              Text(
                'Philippe Troussier',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Icon(Icons.star),
              Text('Excellence'),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 20),
              SizedBox(
                //width: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      height: 40,
                      //width: 80,
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          tags[index],
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Divider(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xffF4F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Do you have something to share with Cook? Leave a review now! Your rating and comments will be displayed anonymously.',
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Get.back();
                  showModalBottomSheet(
                    showDragHandle: true,
                    isScrollControlled: true,
                    context: Get.context!,
                    builder: (context) {
                      return ReviewShopScreen();
                      // AcademicsAssignmentModalBottomsheet(
                      //   AcademicsAssignmentModalController(),
                      // );
                    },
                  );
                },
                child: Text('Next', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
