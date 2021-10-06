enum PhotoSource {
  CAMERA, GALLERY,
}

class PhotoMemo {
  String? docId; // Firestore auto generated doc Id
  late String createdBy; // email == user id
  late String title;
  late String memo;
  late String photoFilename; // at Cloud Storage
  late String photoURL;
  DateTime? timestamp;
  late List<dynamic> sharedWith; // list of emails
  late List<dynamic> imageLabels; // ML image labels

  PhotoMemo({
    this.docId,
    this.createdBy = '',
    this.title = '',
    this.memo = '',
    this.photoFilename = '',
    this.photoURL = '',
    this.timestamp,
    List<dynamic>? sharedWith,
    List<dynamic>? imageLabels,
  }) {
    this.sharedWith = sharedWith == null ? [] : [...sharedWith];
    this.imageLabels = imageLabels == null ? [] : [...imageLabels];
  }

  static String? validateTitle(String? value) {
    return value == null || value.trim().length < 3 ? 'Title too short' : null;
  }

  static String? validateMemo(String? value) {
    return value == null || value.trim().length < 5 ? 'Memo too short' : null;
  }

  static String? validateSharedWith(String? value) {
    if (value == null || value.trim().length == 0) return null;

    // in parenthesis split , and whitespace in string and + means repeated
    List<String> emailList = value.trim().split(RegExp('(,| )+')).map((e) => e.trim()).toList(); 
    for (String e in emailList) {
      if (e.contains('@') && e.contains('.')) continue;
      else return 'Invalid email list: comma or space separated list';
    }
  
  }
}
