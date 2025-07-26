// import 'package:flutter/material.dart';

// class ShimmerLoading extends StatelessWidget {
//   final Widget child;
//   final bool isLoading;
//   const ShimmerLoading({super.key, required this.child, required this.isLoading});
//   @override
//   Widget build(BuildContext context) {
//     if (!isLoading) {
//       return child;
//     }
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: child,
//     );
//   }
// }