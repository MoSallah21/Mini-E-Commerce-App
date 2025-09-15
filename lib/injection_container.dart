import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/cache/cache_helper.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/register_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/signin_google_usecase.dart';
import 'package:ecommerce/features/auth/domain/usecases/signout_usecase.dart';
import 'package:ecommerce/features/auth/presentation/provider/login_state.dart';
import 'package:ecommerce/features/auth/presentation/provider/register_state.dart';
import 'package:ecommerce/features/localization/data/locale_local_datasource.dart';
import 'package:ecommerce/features/localization/presentation/locale_provider.dart';
import 'package:ecommerce/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecases/get_product_usecase.dart';
import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ecommerce/features/products/presentation/provider/cart_state.dart';
import 'package:ecommerce/features/products/presentation/provider/product_state.dart';
import 'package:ecommerce/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:ecommerce/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ecommerce/features/profile/domain/repositories/profile_repository.dart';
import 'package:ecommerce/features/profile/domain/usecases/add_profile.dart';
import 'package:ecommerce/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ecommerce/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/provider/profile_state.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(()=> FirebaseFirestore.instance);

  // DataSources Registration
  _registerDataSources();

  // Repository Registration
  _registerRepositories();

  // UseCases Registration
  _registerUseCases();

  _registerProvider();

}

void _registerDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<AuthLocalDatasource>(
          () => AuthLocalDatasourceImp(secureStorage: sl()));
  sl.registerLazySingleton<ProductRemoteDatasource>(
          () => ProductRemoteDatasourceImpl());
  sl.registerLazySingleton<ProfileRemoteDataSource>(
          () => ProfileRemoteDataSourceImpl(firestore: sl(), storage: sl()));
  sl.registerLazySingleton<ProfileLocalDatasource>(
          () => ProfileLocalDatasourceImp());
  sl.registerLazySingleton(() => LocaleLocalDataSource());

}

void _registerRepositories() {
  sl.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()));
  sl.registerLazySingleton<ProductRepository>(
          () => ProductRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ProfileRepository>(
          () => ProfileRepositoryImpl(remoteDataSource: sl(), localDatasource: sl(), authLocalDatasource: sl()));
}




void _registerUseCases() {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));


  sl.registerLazySingleton(() => GetProductUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));

  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => AddProfileUseCase(sl()));

}
void _registerProvider() {
  sl.registerFactory(() =>
      LoginState(
    loginUseCase: sl(), signInWithGoogleUseCase: sl(),
  ));
  sl.registerFactory(() => RegisterState(registerUseCase: sl(), signInWithGoogleUseCase: sl()));
  sl.registerFactory(() => CartProvider());
  sl.registerFactory(() => LocaleProvider(sl()));

  sl.registerFactory(() => ProductState(getProductsUseCase: sl(), getProductUseCase: sl(), ));
  sl.registerFactory(() => ProfileProvider(sl(),sl(),sl()));

}