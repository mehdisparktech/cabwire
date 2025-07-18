import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/driver/profile/presenter/driver_profile_presenter.dart';
import 'package:flutter/material.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final DriverProfilePresenter presenter;
  const DeleteAccountDialog({
    super.key,
    required this.onConfirm,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return PresentableWidgetBuilder(
      presenter: presenter,
      builder: () {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Want to delete account !',
                  style: TextStyle(
                    fontSize: px22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                gapH10,
                Text(
                  'Please confirm your password to remove your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: px16, color: Colors.black87),
                ),
                gapH20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: px16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    gapH10,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: presenter.deleteAccountPasswordController,
                        obscureText:
                            !(presenter.currentUiState.showPassword ?? false),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              presenter.currentUiState.showPassword ?? false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.deepOrange,
                            ),
                            onPressed: () {
                              presenter.toggleShowPassword();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                gapH20,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: px16, color: Colors.black),
                        ),
                      ),
                    ),
                    gapW10,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          presenter.deleteAccount(
                            presenter.deleteAccountPasswordController.text,
                          );
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: px16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
