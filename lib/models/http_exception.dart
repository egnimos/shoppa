class  HttpException implements Exception {
  
  final String message;

  //construct
  HttpException(this.message);

  @override
  String toString() {
    return message;
    //return super.toString();
  }
}
//