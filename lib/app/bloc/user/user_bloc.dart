import 'package:flutter_application_1/app/bloc/user/user_event.dart';
import 'package:flutter_application_1/app/bloc/user/user_state.dart';
import 'package:flutter_application_1/domain/useCases/get_user_post.dart';
import 'package:flutter_application_1/domain/useCases/get_user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
    final GetUserPost getUserPost;
    final GetUserProfile getUserProfile;

    UserBloc({
        required this.getUserPost,
        required this.getUserProfile,
    }) : super(const UserState()) {
        on<LoadUserProfile>(_onLoadUserProfile);
        on<LoadUserPosts>(_onLoadUserPosts);
    }

    Future<void> _onLoadUserProfile(
        LoadUserProfile event,
        Emitter<UserState> emit,
    ) async {
        emit(state.copyWith(isLoading: true));
        try {
            final user = await getUserProfile();
            emit(state.copyWith(isLoading: false, user: user));
        } catch (e) {
            emit(state.copyWith(isLoading: false, error: e.toString()));
        }
    }

    Future<void> _onLoadUserPosts(
        LoadUserPosts event,
        Emitter<UserState> emit,
    ) async {
        emit(state.copyWith(isLoading: true));
        try {
            final posts = await getUserPost();
            emit(state.copyWith(isLoading: false, posts: posts));
        } catch (e) {
            emit(state.copyWith(isLoading: false, error: e.toString()));
        }
    }

}