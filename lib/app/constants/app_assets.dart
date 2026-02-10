class AppAssets {
  static const String _baseImage = 'assets/image/';
  static const String _baseLogo = 'assets/logo/';
  static const String _baseSvgIcons = 'assets/svg/icons/';
  static const String _baseSvgLogo = 'assets/svg/logo/';

  // PNG Logos
  static const String logoXl = '${_baseLogo}logo_xl.png';
  static const String logoXs = '${_baseLogo}logo_xs.png';

  // Images
  static const String bg = '${_baseImage}bg.jpg';

  // SVG Icons
  static const String calenderIcon = '${_baseSvgIcons}calender.svg';
  static const String editIcon = '${_baseSvgIcons}edit.svg';
  static const String notificationIcon = '${_baseSvgIcons}notification.svg';
  static const String peopleIcon = '${_baseSvgIcons}people.svg';

  // SVG Logos
  static const String logoXlSvg = '${_baseSvgLogo}logo_xl.svg';
  static const String logoXsSvg = '${_baseSvgLogo}logo_xs.svg';

  // Static methods for dynamic access
  static String getImagePath(String name) => '$_baseImage$name';
  static String getLogoPath(String name) => '$_baseLogo$name';
  static String getSvgIconPath(String name) => '$_baseSvgIcons$name';
  static String getSvgLogoPath(String name) => '$_baseSvgLogo$name';
}
