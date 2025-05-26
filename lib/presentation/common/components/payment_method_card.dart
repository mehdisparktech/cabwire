import 'package:flutter/material.dart';

class PaymentMethod {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isRecommended;
  final String? subtitle;

  const PaymentMethod({
    required this.title,
    required this.icon,
    this.isSelected = false,
    this.isRecommended = false,
    this.subtitle,
  });

  // Helper method to create a copy with modified properties
  // This is useful for state management when selection changes
  PaymentMethod copyWith({
    String? title,
    IconData? icon,
    bool? isSelected,
    bool? isRecommended,
    String? subtitle,
  }) {
    return PaymentMethod(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
      isRecommended: isRecommended ?? this.isRecommended,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}

// Main payment method selection widget with all functionality in one class
class PaymentMethodSelector extends StatefulWidget {
  final List<PaymentMethod> paymentMethods;
  final Function(PaymentMethod)? onPaymentMethodSelected;
  final double? width;
  final EdgeInsets? padding;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    this.onPaymentMethodSelected,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 15),
  });

  @override
  State<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {
  // Track which payment method is currently selected
  // Using late initialization because we'll set it in initState
  late List<PaymentMethod> _methods;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the payment methods for state management
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
        children:
            _methods.map((method) => _buildPaymentMethodCard(method)).toList(),
      ),
    );
  }

  // Builder method for the main container decoration
  // This creates the outer container styling with shadow and rounded corners
  BoxDecoration _buildMainContainerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x3F033FCF), // Blue tinted shadow for premium look
          blurRadius: 4,
          offset: Offset.zero,
        ),
      ],
    );
  }

  // Builder method for individual payment method cards
  // This is where the reusability magic happens - one method handles all variations
  Widget _buildPaymentMethodCard(PaymentMethod method) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ), // Space between cards
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 17),
      decoration: _buildCardDecoration(method.isSelected),
      child: Row(
        children: [
          // Left side: Icon and title section
          Expanded(child: _buildMethodInfo(method)),

          // Right side: Selection indicator
          _buildSelectionIndicator(method),
        ],
      ),
    );
  }

  // Builder method for card decoration based on selection state
  // This demonstrates how we can vary styling based on state
  BoxDecoration _buildCardDecoration(bool isSelected) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      // Enhanced shadow for selected state to show visual feedback
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
            child: Icon(
              method.icon,
              size: 16,
              color: method.isSelected ? Colors.white : Colors.grey[600],
            ),
          ),

          const SizedBox(width: 10), // Consistent spacing
          // Payment method title and optional subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(method.title, style: _getMethodTitleStyle(method)),
                // Show subtitle if provided
                if (method.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(method.subtitle!, style: _getMethodSubtitleStyle()),
                ],
                // Show recommended badge if applicable
                if (method.isRecommended) ...[
                  const SizedBox(height: 4),
                  _buildRecommendedBadge(),
                ],
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
        width: 48,
        height: 48,
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
                ? const Icon(Icons.check, color: Color(0xFF033FCF), size: 24)
                : null, // Empty circle when not selected
      ),
    );
  }

  // Builder method for recommended badge
  Widget _buildRecommendedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Recommended',
        style: TextStyle(
          color: Colors.green[700],
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
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

  // Helper method for subtitle styling
  TextStyle _getMethodSubtitleStyle() {
    return const TextStyle(
      color: Color(0xFF666666),
      fontSize: 14,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w300,
    );
  }

  // Method to handle payment method selection with state management
  void _handleMethodSelection(PaymentMethod selectedMethod) {
    setState(() {
      // Update the methods list to reflect new selection
      // This demonstrates proper state management for selection UI
      _methods =
          _methods.map((method) {
            return method.copyWith(
              isSelected: method.title == selectedMethod.title,
            );
          }).toList();
    });

    // Notify parent widget about the selection through callback
    if (widget.onPaymentMethodSelected != null) {
      widget.onPaymentMethodSelected!(selectedMethod);
    }
  }
}
