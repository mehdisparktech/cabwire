import 'package:cabwire/core/config/app_color.dart';
import 'package:cabwire/core/static/ui_const.dart';
import 'package:cabwire/presentation/common/components/common_image.dart';
import 'package:cabwire/presentation/common/components/custom_text.dart';
import 'package:flutter/material.dart';

class PaymentMethod {
  final String title;
  final String imageSrc;
  final bool isSelected;
  final bool isRecommended;
  final String? subtitle;

  const PaymentMethod({
    required this.title,
    required this.imageSrc,
    this.isSelected = false,
    this.isRecommended = false,
    this.subtitle,
  });

  PaymentMethod copyWith({
    String? title,
    String? imageSrc,
    bool? isSelected,
    bool? isRecommended,
    String? subtitle,
  }) {
    return PaymentMethod(
      title: title ?? this.title,
      imageSrc: imageSrc ?? this.imageSrc,
      isSelected: isSelected ?? this.isSelected,
      isRecommended: isRecommended ?? this.isRecommended,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

class PaymentMethodSelector extends StatefulWidget {
  final List<PaymentMethod> paymentMethods;
  final Function(PaymentMethod)? onPaymentMethodSelected;
  final double? width;
  final EdgeInsets? padding;
  final bool isIWillPay;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    this.onPaymentMethodSelected,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
    this.isIWillPay = false,
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  late List<PaymentMethod> _methods;

  @override
  void initState() {
    super.initState();
    _methods = List.from(widget.paymentMethods);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      padding: widget.padding,
      decoration: _buildMainContainerDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children:
                _methods
                    .map((method) => _buildPaymentMethodCard(method))
                    .toList(),
          ),
          gapH20,
          if (widget.isIWillPay)
            CustomText(
              'Who pays the delivery fee?',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          if (widget.isIWillPay) _buildPaymentSendWayCard(),
        ],
      ),
    );
  }

  BoxDecoration _buildMainContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Color(0x3F033FCF), blurRadius: 4, offset: Offset.zero),
      ],
    );
  }

  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ), // Space between cards
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 17),
      decoration: _buildCardDecoration(method.isSelected),
      child: Row(
        children: [
          Expanded(child: _buildMethodInfo(method)),
          _buildSelectionIndicator(method),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isSelected) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),

      boxShadow: [
        BoxShadow(
          color: isSelected ? const Color(0x40033FCF) : const Color(0x26000000),
          blurRadius: isSelected ? 6 : 4, // More prominent shadow when selected
          offset: Offset.zero,
        ),
      ],
      // Optional: Add border for selected state
      border:
          isSelected
              ? Border.all(color: const Color(0xFF033FCF), width: 2)
              : null,
    );
  }

  // Builder method for the method information (icon and text)
  Widget _buildMethodInfo(PaymentMethod method) {
    return GestureDetector(
      onTap: () => _handleMethodSelection(method),
      child: Row(
        children: [
          // Payment method icon with consistent sizing
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color:
                  method.isSelected
                      ? const Color(0xFF033FCF)
                      : Colors.grey[400],
              borderRadius: BorderRadius.circular(4),
            ),
            child: CommonImage(
              imageSrc: method.imageSrc,
              imageType: ImageType.svg,
              width: 16,
              height: 16,
              imageColor: method.isSelected ? Colors.white : Colors.grey[600],
            ),
          ),

          const SizedBox(width: 10), // Consistent spacing
          // Payment method title and optional subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    method.title,
                    style: _getMethodTitleStyle(method),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder method for selection indicator (radio button style)
  Widget _buildSelectionIndicator(PaymentMethod method) {
    return GestureDetector(
      onTap: () => _handleMethodSelection(method),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color:
                method.isSelected ? const Color(0xFF033FCF) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child:
            method.isSelected
                ? const Icon(Icons.check, color: Color(0xFF033FCF), size: 14)
                : null, // Empty circle when not selected
      ),
    );
  }

  // Helper method for method title styling based on selection state
  TextStyle _getMethodTitleStyle(PaymentMethod method) {
    return TextStyle(
      color: const Color(0xFF1E1E1E),
      fontSize: 18,
      fontFamily: 'Outfit',
      // Bold text for selected method to show visual hierarchy
      fontWeight: method.isSelected ? FontWeight.w600 : FontWeight.w400,
      height: 1.5,
      letterSpacing: 0.36,
    );
  }

  void _handleMethodSelection(PaymentMethod selectedMethod) {
    setState(() {
      _methods =
          _methods.map((method) {
            return method.copyWith(
              isSelected: method.title == selectedMethod.title,
            );
          }).toList();
    });

    if (widget.onPaymentMethodSelected != null) {
      widget.onPaymentMethodSelected!(selectedMethod);
    }
  }

  Widget _buildPaymentSendWayCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Radio(
            value: true,
            groupValue: true,
            onChanged: (value) {},
            activeColor: AppColor.passengerPrimaryColor,
          ),
          gapW10,
          CustomText('I will pay'),
          gapW10,
          Radio(
            value: false,
            groupValue: false,
            onChanged: (value) {},
            activeColor: AppColor.passengerPrimaryColor,
          ),
          gapW10,
          CustomText('The receiver will pay'),
        ],
      ),
    );
  }
}
