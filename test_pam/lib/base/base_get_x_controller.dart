import 'package:domain/errors/app_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

// Baza controllerelor (GetX): acces la get_it și stările comune Loading / Error, folosite de ambele ecrane.
class BaseGetXController extends GetxController {
  final getIt = GetIt.instance;

  RxBool isLoading = true.obs;
  Rxn<String> errorMessage = Rxn<String>();

  // Rulează o cerere asincronă cu Loading -> Success (onSuccess) sau Error (mesajul din AppException).
  Future<void> runRequest<T>(Future<T> Function() request, void Function(T result) onSuccess) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      onSuccess(await request());
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } catch (e, stack) {
      debugPrint('Unexpected error: $e\n$stack'); // detaliile tehnice doar în consolă, nu pe ecran
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
