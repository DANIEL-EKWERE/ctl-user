import '../../core/app_export.dart';
import 'controller/review_shop_controller.dart';
//import 'package:ctluser/presentation/ReviewShopScreen/controller/review_controller.dart';
import 'package:flutter/material.dart';

ReviewShopController controller = Get.put(ReviewShopController());

class ReviewShopScreen extends StatefulWidget {
  const ReviewShopScreen({super.key});

  @override
  State<ReviewShopScreen> createState() => _ReviewShopScreenState();
}

class _ReviewShopScreenState extends State<ReviewShopScreen> {
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
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     width: 40,
          //     height: 10,
          //     decoration: BoxDecoration(
          //       color: Colors.grey,
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          // ),
          Text('Rate Shop'),
          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 35),
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: CustomImageView(
                  imagePath: 'assets/images/img_import_image_8.png',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Starbucks',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  CustomImageView(imagePath: ImageConstant.imgCheckmarkTeal700),
                ],
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
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF4F5F7),
                      ),
                      child: Text(
                        'previous',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
