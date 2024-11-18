import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sns_app/data/datasources/create_post/create_post_local_datasource.dart';
import 'package:sns_app/data/datasources/create_post/create_post_remote_datasource.dart';
import 'package:sns_app/data/datasources/signin/signin_datasource.dart';
import 'package:sns_app/data/datasources/signup/signup_datasource.dart';
import 'package:sns_app/data/repositories/creat_post/create_post_local_repository_impl.dart';
import 'package:sns_app/data/repositories/creat_post/create_post_remote_repository_impl.dart';
import 'package:sns_app/data/repositories/signin/signin_repository_impl.dart';
import 'package:sns_app/data/repositories/signup/signup_repository_impl.dart';
import 'package:sns_app/domain/repositories/create_post/create_post_local_repository.dart';
import 'package:sns_app/domain/repositories/create_post/create_post_remote_repository.dart';
import 'package:sns_app/domain/repositories/signin/signin_repository.dart';
import 'package:sns_app/domain/repositories/signup/signup_repository.dart';
import 'package:sns_app/domain/usecases/create_post/create_post_local_usecase.dart';
import 'package:sns_app/domain/usecases/create_post/create_post_remote_usecase.dart';
import 'package:sns_app/domain/usecases/signin/signin_usecase.dart';
import 'package:sns_app/domain/usecases/signup/signup_usecase.dart';
import 'package:sqflite/sqflite.dart';

final injector = GetIt.instance;

void provideDataSources() {
  // Create Post
  injector.registerFactory<CreatePostLocalDatasource>(
      () => CreatePostLocalDatasource());
  injector.registerFactory<CreatePostRemoteDatasource>(
      () => CreatePostRemoteDatasource());
  // SignIn
  injector.registerFactory<SigninDatasource>(() => SigninDatasource());
  // SignUp
  injector.registerFactory<SignupDatasource>(() => SignupDatasource());
}

void provideRepositories() {
  // Create Post
  injector.registerFactory<CreatePostLocalRepository>(() =>
      CreatePostLocalRepositoryImpl(injector.get<CreatePostLocalDatasource>()));
  injector.registerFactory<CreatePostRemoteRepository>(() =>
      CreatePostRemoteRepositoryImpl(
          injector.get<CreatePostRemoteDatasource>()));
  // SignIn
  injector.registerFactory<SigninRepository>(
      () => SigninRepositoryImpl(injector.get<SigninDatasource>()));
  // SignUp
  injector.registerFactory<SignupRepository>(
      () => SignupRepositoryImpl(injector.get<SignupDatasource>()));
}

void provideUseCases() {
  // Create Post
  injector.registerFactory<CreatePostLocalUsecase>(
      () => CreatePostLocalUsecase(injector.get<CreatePostLocalRepository>()));
  injector.registerFactory<CreatePostRemoteUsecase>(() =>
      CreatePostRemoteUsecase(injector.get<CreatePostRemoteRepository>()));
  // SignIn
  injector.registerFactory<SigninUsecase>(
      () => SigninUsecase(injector.get<SigninRepository>()));
  // SignUp
  injector.registerFactory<SignupUsecase>(
      () => SignupUsecase(injector.get<SignupRepository>()));
}

// Create Post
Future<void> provideDatabases() async {
  final directory = await getApplicationDocumentsDirectory();
  const String dbName = "sns_app.db";
  final dbPath = join(directory.path, dbName);

  final Database db = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      // Profile 수정 - 마지막 id 값을 기준으로 sync를 맞추고 모두 제거
      await db.execute('''
        CREATE TABLE IF NOT EXISTS profile (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId TEXT UNIQUE,
          userName TEXT,
          bio TEXT,
          name TEXT,
          profileImageUrl TEXT
        )
      ''');

      // Post 생성 - 모든 id 값을 기준으로 sync를 맞추고 모두 제거 ( 여기서 postId는 firestore의 postId가 아님 )
      // 로컬에 저장된 post들의 id라고 생각하면 된다.
      await db.execute('''
        CREATE TABLE IF NOT EXISTS create_post (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          content TEXT,
          imagePath TEXT,
          createdAt TEXT
        )
      ''');

      // Post 수정 - 동일한 postId가 있다면 마지막 id를 기준으로 sync를 맞추고 해당 postId를 모두 제거 ( for로 모든 아이템 순회 )
      await db.execute('''
        CREATE TABLE IF NOT EXISTS modify_post (
          postId TEXT PRIMARY KEY,
          content TEXT,
          imagePath TEXT
        )
      ''');

      // Post 제거 - 모든 id 값을 기준으로 sync를 맞추고 모두 제거
      await db.execute('''
        CREATE TABLE IF NOT EXISTS delete_post (
          postId TEXT PRIMARY KEY
        )
      ''');

      // Feed 좋아요 및 댓글 - 동일한 postId가 있다면 마지막 id를 기준으로 sync를 맞추고 해당 postId를 모두 제거 ( for로 모든 아이템 순회 )
      await db.execute('''
        CREATE TABLE IF NOT EXISTS feed (
          postId TEXT PRIMARY KEY,
          isLiked INTEGER NOT NULL DEFAULT 0,
          comment TEXT,
          timestamp TEXT
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        // 스키마 변경시 적용하기
      }
    },
  );

  injector.registerSingleton<Database>(db);
}
