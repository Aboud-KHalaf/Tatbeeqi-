import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tatbeeqi/core/routing/app_routes.dart';
import 'package:tatbeeqi/core/routing/routes_args.dart';

import 'package:tatbeeqi/features/notes/presentation/views/add_update_note_view.dart';

final List<GoRoute> notesRoutes = <GoRoute>[
  GoRoute(
    path: AppRoutes.addUpdateNote,
    builder: (BuildContext context, GoRouterState state) {
      final args = state.extra as AddUpdateNoteArgs?;
      if (args == null) {
        return const Scaffold(
          body: Center(
            child: Text('Invalid note data'),
          ),
        );
      }
      if (args.note == null) {
        return AddOrUpdateNoteView(courseId: args.courseId);
      } else {
        return AddOrUpdateNoteView(courseId: args.courseId, note: args.note);
      }
    },
  ),
];
