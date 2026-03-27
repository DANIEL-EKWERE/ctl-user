// Schedule Delivery Model
import '../../../core/app_export.dart';

/// This class defines the variables used in the [login_eight_bottomsheet],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class LoginEightModel {
  // Default selected date and time
  RxString selectedDate = "Today".obs;
  RxString selectedTime = "9:00 AM".obs;

  // Available dates and times for delivery
  List<String> availableDates = [
    "Today",
    "Tomorrow",
    "Wed, Mar 26",
    "Thu, Mar 27",
    "Fri, Mar 28",
  ];

  List<String> availableTimes = [
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
  ];
}
