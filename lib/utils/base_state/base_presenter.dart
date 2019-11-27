abstract class BaseViewContract {
  void setLoadingState();
  void setErrorState({exception});
  void setShowingState();
}