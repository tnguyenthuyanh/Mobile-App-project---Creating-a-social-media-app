class Comment {
  // keys for Firestore doc
  static const UID = 'uid';
  static const COMMENTED_BY = 'commentedBy';
  static const PHOTO_ID = 'photoID';
  static const CONTENT = 'content';
  static const TIMESTAMP = 'timestamp';
  static const SEEN = 'seen';

  String? docId; // Firestore auto generated doc Id
  late String commentedBy; // email 
  late String uid;
  late String photoId; 
  late String content;
  late int seen;
  DateTime? timestamp;

  Comment({
    this.docId,
    this.uid = '',
    this.commentedBy = '',
    this.photoId = '',
    this.content = '',
    this.timestamp,
    this.seen = 0,
  });

  Comment.clone(Comment p) {
    this.docId = p.docId;
    this.uid = p.uid;
    this.commentedBy = p.commentedBy;
    this.photoId = p.photoId;
    this.content = p.content;
    this.timestamp = p.timestamp;
    this.seen = p.seen;
  }

  // // a.assign(b) =====> a = b
  // void assign(PhotoMemo p) {
  //   this.docId = p.docId;
  //   this.uid = p.uid;
  //   this.createdBy = p.createdBy;
  //   this.title = p.title;
  //   this.memo = p.memo;
  //   this.photoFilename = p.photoFilename;
  //   this.photoURL = p.photoURL;
  //   this.timestamp = p.timestamp;
  //   this.sharedWith.clear();
  //   this.sharedWith.addAll(p.sharedWith);
  //   this.imageLabels.clear();
  //   this.imageLabels.addAll(p.imageLabels);
  // }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      UID: this.uid,
      COMMENTED_BY: this.commentedBy,
      PHOTO_ID: this.photoId,
      CONTENT: this.content,
      SEEN: this.seen,
      TIMESTAMP: this.timestamp,
    };
  }

  static Comment? fromFirestoreDoc({
    required Map<String, dynamic> doc,
    required String docId,
  }) {
    for (var key in doc.keys) {
      if (doc[key] == null) return null;
    }
    return Comment(
      docId: docId,
      uid: doc[UID],
      commentedBy: doc[COMMENTED_BY] ??= 'N/A', // if null give a value as 'N/A'
      photoId: doc[PHOTO_ID],
      content: doc[CONTENT],
      seen: doc[SEEN],
      timestamp: doc[TIMESTAMP] != null  
      ? DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch)
      : DateTime.now(),
    );
  }

  static String? validateComment(String? value) {
    return value == null || value.trim().length < 6 ? 'Comment too short' : null;
  }

}
