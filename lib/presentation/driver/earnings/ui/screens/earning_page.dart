import 'package:cabwire/core/config/app_assets.dart';
import 'package:cabwire/core/config/app_screen.dart';
import 'package:cabwire/core/di/service_locator.dart';
import 'package:cabwire/core/external_libs/presentable_widget_builder.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/core/utility/utility.dart';
import 'package:cabwire/presentation/common/components/auth/custom_button.dart';
import 'package:cabwire/presentation/driver/earnings/presenter/earning_presenter.dart';
import 'package:cabwire/presentation/driver/earnings/presenter/earning_ui_state.dart';
import 'package:cabwire/presentation/driver/earnings/ui/widgets/daily_earnings_card.dart';
import 'package:cabwire/presentation/driver/earnings/ui/widgets/earnings_summary_card.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:flutter/material.dart';

class EarningsPage extends StatelessWidget {
  final EarningsPresenter presenter = locate<EarningsPresenter>();

  EarningsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, presenter),
      body: PresentableWidgetBuilder(
        presenter: presenter,
        builder: () {
          final uiState = presenter.currentUiState;

          // if (uiState.isLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          if (uiState.userMessage != null && uiState.userMessage!.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(uiState.userMessage!)));
              presenter.addUserMessage('');
            });
          }

          final data = uiState.earningsData;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EarningsSummaryCard(
                    totalEarnings: data.totalEarnings,
                    availableEarnings: data.availableEarnings,
                  ),
                  gapH20,
                  _buildEarningsContent(uiState),
                  gapH20,
                  CustomButton(
                    text: 'Withdraw Amount',
                    onPressed: presenter.withdrawAmount,
                    radius: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEarningsContent(EarningsUiState uiState) {
    final data = uiState.earningsData;

    // For today filter, show a single card
    if (uiState.selectedFilter == EarningsFilter.today) {
      return DailyEarningsCard(
        date: data.currentDate,
        todayEarning: data.todayEarning,
        cashPayment: data.cashPayment,
        onlinePayment: data.onlinePayment,
        walletAmount: data.walletAmount,
      );
    }
    // For week/month filters, show a list of cards
    else {
      // If no daily data available, show a message
      if (data.dailyEarnings.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No earnings data available for this period'),
          ),
        );
      }

      // Show the list of daily cards
      return Expanded(
        child: ListView.separated(
          itemCount: data.dailyEarnings.length,
          separatorBuilder: (context, index) => gapH10,
          itemBuilder: (context, index) {
            final daily = data.dailyEarnings[index];
            return DailyEarningsCard(
              date: daily.date,
              todayEarning: daily.todayEarning,
              cashPayment: daily.cashPayment,
              onlinePayment: daily.onlinePayment,
              walletAmount: daily.walletAmount,
            );
          },
        ),
      );
    }
  }

  AppBar _buildAppBar(BuildContext context, EarningsPresenter presenter) {
    return AppBar(
      title: const Text('Earning Details'),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      centerTitle: true,
      leading: IconButton(
        onPressed: presenter.goBack,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: () {
            showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                MediaQuery.of(context).size.width - 150,
                kToolbarHeight,
                MediaQuery.of(context).size.width - 50,
                0,
              ),
              items: <PopupMenuEntry<String>>[
                _buildPopupMenuItem(
                  'Today',
                  'today',
                  presenter.currentUiState.selectedFilter,
                ),
                const PopupMenuDivider(),
                _buildPopupMenuItem(
                  'This Week',
                  'week',
                  presenter.currentUiState.selectedFilter,
                ),
                const PopupMenuDivider(),
                _buildPopupMenuItem(
                  'This Month',
                  'month',
                  presenter.currentUiState.selectedFilter,
                ),
              ],
            ).then((String? value) {
              presenter.onFilterSelected(value);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacityInt(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: CommonImage(
              width: 24.px,
              height: 24.px,
              imageType: ImageType.svg,
              imageSrc: AppAssets.icSort,
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String title,
    String value,
    EarningsFilter currentFilter,
  ) {
    final isSelected =
        (value == 'today' && currentFilter == EarningsFilter.today) ||
        (value == 'week' && currentFilter == EarningsFilter.week) ||
        (value == 'month' && currentFilter == EarningsFilter.month);
    return PopupMenuItem<String>(
      value: value,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.px,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.orange[700] : Colors.black,
        ),
      ),
    );
  }
}
