import 'package:flutter/material.dart';

/// [FutureErrorWidget] is the widget that is shown when there is an error in the future.
class FutureErrorWidget extends StatelessWidget {
  /// [FutureErrorWidget] constructor
  const FutureErrorWidget({
    this.msg = 'Loading ...',
    super.key,
  });

  /// [msg] is the message to be shown.
  final String msg;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 64,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 20),
          const Text(
            'Localize And Translate:',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Colors.red, fontSize: 25),
          ),
          const SizedBox(height: 10),
          Text(
            '"$msg"',
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.red, fontSize: 14),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
