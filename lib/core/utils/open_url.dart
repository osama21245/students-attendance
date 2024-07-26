import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import '../theme/app_pallete.dart';

void openUrl(String url) {
  launchUrl(
    Uri.parse(url),
    customTabsOptions: CustomTabsOptions(
      colorSchemes: CustomTabsColorSchemes.defaults(
        toolbarColor: AppPallete.backgroundColor,
      ),
      shareState: CustomTabsShareState.on,
      urlBarHidingEnabled: true,
      showTitle: true,
      closeButton: CustomTabsCloseButton(
        icon: CustomTabsCloseButtonIcons.back,
      ),
    ),
    safariVCOptions: SafariViewControllerOptions(
      preferredBarTintColor: AppPallete.backgroundColor,
      preferredControlTintColor: AppPallete.whiteColor,
      barCollapsingEnabled: true,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    ),
  );
}
