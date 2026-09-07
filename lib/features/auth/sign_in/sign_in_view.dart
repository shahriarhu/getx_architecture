import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/config/app_config.dart';
import '../../../core/extensions/num_extensions.dart';
import '../../../l10n/translation_keys.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/buttons/app_button.dart';
import '../../../widgets/inputs/app_text_field.dart';
import '../../../widgets/layouts/app_scaffold.dart';
import '../../../widgets/layouts/responsive_layout.dart';
import 'sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppScaffold(
      body: ConstrainedBody(
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              AppSpacing.xxxl.verticalSpace,
              // ListView gives children a tight width, so the badge needs an
              // Align to keep its own size.
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              AppSpacing.xl.verticalSpace,
              AppText.headlineMedium(LocaleKeys.welcomeBack.tr),
              AppSpacing.sm.verticalSpace,
              AppText.bodyMedium(
                LocaleKeys.signInSubtitle.tr,
                color: colors.onSurfaceVariant,
              ),
              AppSpacing.xxl.verticalSpace,

              AppTextField(
                label: LocaleKeys.email.tr,
                hint: LocaleKeys.emailHint.tr,
                controller: controller.emailController,
                validator: controller.emailValidator,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline,
                isRequired: true,
                autofillHints: const [AutofillHints.email],
              ),
              AppSpacing.lg.verticalSpace,

              AppTextField.password(
                label: LocaleKeys.password.tr,
                hint: LocaleKeys.passwordHint.tr,
                controller: controller.passwordController,
                validator: controller.passwordValidator,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => controller.submit(),
                isRequired: true,
              ),

              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AppButton.text(
                  label: LocaleKeys.forgotPassword.tr,
                  onPressed: () {},
                ),
              ),
              AppSpacing.lg.verticalSpace,

              Obx(
                () => AppButton(
                  label: LocaleKeys.signIn.tr,
                  loading: controller.isSubmitting.value,
                  onPressed: controller.submit,
                ),
              ),

              // Demo affordance — never shipped to production.
              if (AppConfig.instance.showDevTools) ...[
                AppSpacing.sm.verticalSpace,
                AppButton.text(
                  label: LocaleKeys.continueAsGuest.tr,
                  expanded: true,
                  onPressed: controller.continueAsDemoUser,
                ),
              ],
              AppSpacing.xxl.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
