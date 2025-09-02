
import 'package:flutter/material.dart';
import 'package:tatbeeqi/core/di/service_locator.dart';
import 'package:tatbeeqi/core/network/network_info.dart';

class ConnectivityStreamIcon extends StatelessWidget {
  const ConnectivityStreamIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: sl<NetworkInfo>().connectivityStream,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true; // default to connected
        if (isConnected) return const SizedBox.shrink();
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 4.0),
          child: IconButton.filledTonal(
            onPressed: () {},
            tooltip: 'لا يوجد اتصال بالانترنت',
            style: IconButton.styleFrom(
              backgroundColor: cs.error,
            ),
            icon: Icon(
              Icons.wifi_off_rounded,
              color: cs.errorContainer,
            ),
          ),
        );
      },
    );
  }
}
