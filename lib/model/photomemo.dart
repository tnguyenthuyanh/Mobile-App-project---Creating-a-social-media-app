enum PhotoSource {
  CAMERA,
  GALLERY,
}

class PhotoMemo {
  // keys for Firestore doc
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const CREATED_BY = 'createdby';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_FILENAME = 'photofilename';
  static const TIMESTAMP = 'timestamp';
  static const SHARED_WITH = 'sharedwith';
  static const IMAGE_LABELS = 'imagelabels';

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

  PhotoMemo.clone(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.title = p.title;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.sharedWith = [...p.sharedWith];
    this.imageLabels = [...p.imageLabels];
  }

  // a.assign(b) =====> a = b
  void assign(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.title = p.title;
    this.memo = p.memo;
    this.photoFilename = p.photoFilename;
    this.photoURL = p.photoURL;
    this.timestamp = p.timestamp;
    this.sharedWith.clear();
    this.sharedWith.addAll(p.sharedWith);
    this.imageLabels.clear();
    this.imageLabels.addAll(p.imageLabels);
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      TITLE: this.title,
      CREATED_BY: this.createdBy,
      MEMO: this.memo,
      PHOTO_FILENAME: this.photoFilename,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
      SHARED_WITH: this.sharedWith,
      IMAGE_LABELS: this.imageLabels,
    };
  }

  static PhotoMemo? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return PhotoMemo(
      docId: docId,
      createdBy: doc[CREATED_BY] ??= 'N/A', // if null give a value as 'N/A'
      title: doc[TITLE] ??= 'N/A',
      memo: doc[MEMO] ??= 'N/A',
      photoFilename: doc[PHOTO_FILENAME] ??= 'N/A',
      photoURL: doc[PHOTO_URL] ??= 'N/A',
      sharedWith: doc[SHARED_WITH] ??= [],
      imageLabels: doc[IMAGE_LABELS] ??= [],
      timestamp: doc[TIMESTAMP] != null  
      ? DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch)
      : DateTime.now(),
    );
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
    List<String> emailList =
        value.trim().split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String e in emailList) {
      if (e.contains('@') && e.contains('.'))
        continue;
      else
        return 'Invalid email list: comma or space separated list';
    }
  }
}
