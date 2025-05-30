import 'package:flutter/material.dart';

class OrderProgressIndicator extends StatelessWidget {
  final double progress;

  const OrderProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Complete your order — ${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width * progress,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 63,
                child: Row(
                  children: [
                    Container(
                      height: 5,
                      color: Colors.amber,
                      width: MediaQuery.of(context).size.width * progress,
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIcon(
                      icon: Icons.location_on,
                      color: Colors.amber,
                      label: 'Shipping',
                      progress: progress,
                      step: 0.0,
                    ),
                    _buildIcon(
                      icon: Icons.account_balance_wallet,
                      color: Colors.grey,
                      label: 'Payment',
                      progress: progress,
                      step: 0.5,
                    ),
                    _buildIcon(
                      icon: Icons.verified,
                      color: Colors.grey,
                      label: 'Verify',
                      progress: progress,
                      step: 1.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required Color color,
    required String label,
    required double progress,
    required double step,
  }) {
    final isActive = progress >= step;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.amber : Colors.grey.shade300,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
