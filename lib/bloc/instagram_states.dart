abstract class InstagrameStates {}

class InstagramInitialState extends InstagrameStates {}

// get profie data states
class GetProfileLoadingState extends InstagrameStates {}

class GetProfileSuccessState extends InstagrameStates {}

class GetProfileErrorState extends InstagrameStates {
  final String error;

  GetProfileErrorState(this.error);
}

// bottom navigationbar states
class PageChangeState extends InstagrameStates {}

// post states set
class PostImagChangeState extends InstagrameStates {}

class PostUploadLoadingState extends InstagrameStates {}

class PostUploadSuccessState extends InstagrameStates {}

class PostUploadErrorState extends InstagrameStates {
  final String err;
  PostUploadErrorState(this.err);
}
