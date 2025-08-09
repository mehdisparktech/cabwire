import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentCaptureScreen extends StatefulWidget {
  final String title;
  final String instruction;
  final double overlayAspectRatio; // width / height, e.g., 1.586 for ID-1 card

  const DocumentCaptureScreen({
    super.key,
    this.title = 'Capture Document',
    this.instruction = 'Align the document within the frame',
    this.overlayAspectRatio = 1000 / 630, // ~1.587, ID card ratio
  });

  @override
  State<DocumentCaptureScreen> createState() => _DocumentCaptureScreenState();
}

class _DocumentCaptureScreenState extends State<DocumentCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      cameraController.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera();
    }
  }

  Future<void> _setupCamera() async {
    // Ensure camera permission
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final req = await Permission.camera.request();
      if (!req.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
        Navigator.of(context).pop();
        return;
      }
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No camera found on this device')),
        );
        Navigator.of(context).pop();
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      setState(() {
        _controller = controller;
        _initializeControllerFuture = controller.initialize();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize camera: $e')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _capture() async {
    if (_controller == null) return;
    try {
      await _initializeControllerFuture;
      if (!_controller!.value.isInitialized) return;
      if (_controller!.value.isTakingPicture) return;
      final file = await _controller!.takePicture();
      String resultPath = file.path;
      try {
        final cropped = await ImageCropper().cropImage(
          sourcePath: file.path,
          aspectRatio: const CropAspectRatio(ratioX: 1000, ratioY: 630),
        );
        resultPath = cropped?.path ?? file.path;
      } catch (e) {
        // If cropper activity is missing or fails, fall back to raw image
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cropping unavailable, using original photo.'),
            ),
          );
        }
      }
      if (!mounted) return;
      Navigator.of(context).pop(resultPath);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to capture image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body:
          (_initializeControllerFuture == null)
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(_controller!),
                          _OverlayGuide(
                            aspectRatio: widget.overlayAspectRatio,
                            instruction: widget.instruction,
                          ),
                          Positioned(
                            bottom: 24,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                onPressed: _capture,
                                child: const Icon(Icons.camera_alt),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
    );
  }
}

class _OverlayGuide extends StatelessWidget {
  final double aspectRatio;
  final String instruction;

  const _OverlayGuide({required this.aspectRatio, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: _OverlayPainter(aspectRatio: aspectRatio),
            ),
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Text(
                instruction,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final double aspectRatio;
  _OverlayPainter({required this.aspectRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.55);
    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    final double horizontalMargin = 24;
    double targetWidth = size.width - (horizontalMargin * 2);
    double targetHeight = targetWidth / aspectRatio;
    double verticalOffset = (size.height - targetHeight) / 2;
    if (targetHeight > size.height * 0.8) {
      targetHeight = size.height * 0.8;
      targetWidth = targetHeight * aspectRatio;
      verticalOffset = (size.height - targetHeight) / 2;
    }

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        (size.width - targetWidth) / 2,
        verticalOffset,
        targetWidth,
        targetHeight,
      ),
      const Radius.circular(12),
    );

    final fullPath = Path()..addRect(Offset.zero & size);
    final holePath = Path()..addRRect(rect);
    final overlayPath = Path.combine(
      PathOperation.difference,
      fullPath,
      holePath,
    );

    canvas.drawPath(overlayPath, overlayPaint);
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
