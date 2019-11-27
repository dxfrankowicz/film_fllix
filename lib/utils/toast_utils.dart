import 'package:film_fllix/theme/FF_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static void showShort(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIos: 2,
      backgroundColor: FFColors.toastBgColor,
      textColor: FFColors.toastTextColor,
    );
  }
}