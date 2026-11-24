import 'package:flutter_svg/flutter_svg.dart';

// Iconițele SVG din assets/icons, gata de pus în widget-uri.
class AppIcons {
  static final String _path = 'assets/icons/';

  static SvgPicture get notificationIcon => SvgPicture.asset('${_path}notification.svg');
  static SvgPicture get notificationDot => SvgPicture.asset('${_path}notification_dot.svg');
  static SvgPicture get searchIcon => SvgPicture.asset('${_path}search.svg');
  static SvgPicture get settingIcon => SvgPicture.asset('${_path}setting.svg');
  static SvgPicture get arrowRightIcon => SvgPicture.asset('${_path}arrow_right.svg');
  static SvgPicture get calendarEditIcon => SvgPicture.asset('${_path}calendar_edit.svg');
  static SvgPicture get clockIcon => SvgPicture.asset('${_path}clock.svg');
  static SvgPicture get editCircle => SvgPicture.asset('${_path}edit_circle.svg');
  static SvgPicture get editIcon => SvgPicture.asset('${_path}edit.svg');
  static SvgPicture get messageTextIcon => SvgPicture.asset('${_path}message_text.svg');
  static SvgPicture get locationIcon => SvgPicture.asset('${_path}location.svg');
  static SvgPicture get heartIcon => SvgPicture.asset('${_path}heart.svg');
  static SvgPicture get arrowBackIcon => SvgPicture.asset('${_path}arrow_back.svg');
  static SvgPicture get messageIcon => SvgPicture.asset('${_path}message.svg');
  static SvgPicture get phoneIcon => SvgPicture.asset('${_path}phone.svg');
  static SvgPicture get videoIcon => SvgPicture.asset('${_path}video.svg');
}
