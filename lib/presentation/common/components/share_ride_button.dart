import 'package:flutter/material.dart';
import 'package:cabwire/core/utility/deep_link_helper.dart';

class ShareRideButton extends StatelessWidget {
  final String rideId;
  final String? customMessage;

  const ShareRideButton({super.key, required this.rideId, this.customMessage});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _shareRide(context),
      icon: const Icon(Icons.share),
      label: const Text('Share Ride'),
    );
  }

  Future<void> _shareRide(BuildContext context) async {
    try {
      await DeepLinkHelper.shareRideLink(
        rideId,
        message: customMessage ?? 'Join my ride on Cabwire!',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class CopyRideLinkButton extends StatelessWidget {
  final String rideId;

  const CopyRideLinkButton({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _copyLink(context),
      icon: const Icon(Icons.copy),
      tooltip: 'Copy Link',
    );
  }

  Future<void> _copyLink(BuildContext context) async {
    try {
      await DeepLinkHelper.copyRideLinkToClipboard(rideId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link copied to clipboard!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
