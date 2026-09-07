import 'package:flutter/widgets.dart';

/// Gap helpers, so layouts read as `AppSpacing.md.verticalSpace` instead of
/// scattering `SizedBox`es everywhere.
extension SpacingX on num {
  Widget get verticalSpace => SizedBox(height: toDouble());

  Widget get horizontalSpace => SizedBox(width: toDouble());

  /// Square gap — mostly for `Wrap` children.
  Widget get squareSpace => SizedBox(width: toDouble(), height: toDouble());
}
