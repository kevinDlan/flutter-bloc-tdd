import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/common/screens/screen_under_construction.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/features/auth/domain/entities/user.dart';
import 'package:education_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:education_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:education_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:education_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:education_app/features/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/features/on_boarding/presentation/cubit/onboarding_cubit.dart';
import 'package:education_app/features/on_boarding/presentation/screens/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
