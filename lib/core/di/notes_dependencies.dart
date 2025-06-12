import 'package:get_it/get_it.dart';
import 'package:tatbeeqi/features/notes/data/datasources/note_local_data_source.dart';
import 'package:tatbeeqi/features/notes/data/repositories/note_repository_impl.dart';
import 'package:tatbeeqi/features/notes/domain/repositories/note_repository.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/add_note.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/delete_note.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/get_notes_by_course_id.dart';
import 'package:tatbeeqi/features/notes/domain/usecases/update_note.dart';
import 'package:tatbeeqi/features/notes/presentation/bloc/notes_bloc.dart';

void initNotesDependencies(GetIt sl) {
  // BLoC
  sl.registerFactory(
    () => NotesBloc(
      getNotesByCourseId: sl(),
      addNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNotesByCourseId(sl()));
  sl.registerLazySingleton(() => AddNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // Repository
  sl.registerLazySingleton<NoteRepository>(
      () => NoteRepositoryImpl(localDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<NoteLocalDataSource>(() => NoteLocalDataSourceImpl(databaseService: sl()));
}
