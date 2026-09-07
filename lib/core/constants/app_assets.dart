/// Single source of truth for bundled asset paths.
///
/// Never write an asset path inline — add it here so a missing or renamed file
/// is a one-line fix and the analyzer can find every usage.
abstract final class AppAssets {
  static const _images = 'assets/images';
  static const _icons = 'assets/icons';

  // Images
  static const logo = '$_images/logo.svg';

  // Icons
  static const emptyBox = '$_icons/empty_box.svg';
}
