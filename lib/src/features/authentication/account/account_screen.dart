import 'package:ecommerce_app_miki/src/common_widgets/action_text_button.dart';
import 'package:ecommerce_app_miki/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app_miki/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app_miki/src/features/authentication/account/account_screen_controller.dart';
import 'package:ecommerce_app_miki/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app_miki/src/features/authentication/domain/app_user_model.dart';
import 'package:ecommerce_app_miki/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// rather than using state variables + setState() in your widget, consider using a StateNotifier to control the state, and watch it in the widget

/// ref.listen() useful API to show an alert/SnackBar in response to a state change

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(accountScreenControllerProvider, (_, state) {
      state.showSnackBarOnError(context);
    });

    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading ? const CircularProgressIndicator() : const Text('Account'),
        actions: [
          ActionTextButton(
            text: 'Logout',
            onPressed: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Are you sure?',
                      cancelActionText: 'Cancel',
                      defaultActionText: 'Logout',
                    );

                    // in a button callback we want to do something hence we do not watch the provider
                    // we just read it's value
                    if (logout == true) {
                      ref.read(accountScreenControllerProvider.notifier).signOut();
                    }
                  },
          ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: UserDataTable(),
      ),
    );
  }
}

class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppUser? user = ref.watch(authSateChangesProvider).value;
    final style = Theme.of(context).textTheme.subtitle2!;

    return DataTable(
      columns: [
        DataColumn(
          label: Text('Field', style: style),
        ),
        DataColumn(
          label: Text('Value', style: style),
        ),
      ],
      rows: [
        _makeDataRow('uid', user?.uid ?? '', style),
        _makeDataRow('email', user?.email ?? '', style),
      ],
    );
  }
}

DataRow _makeDataRow(String name, String value, TextStyle style) {
  return DataRow(
    cells: [
      DataCell(
        Text(name, style: style),
      ),
      DataCell(
        Text(value, style: style, maxLines: 2),
      ),
    ],
  );
}
