class Comment {
  // keys for Firestore doc
  static const UID = 'uid';
  static const COMMENTED_BY = 'commentedBy';
  static const PHOTO_ID = 'photoID';
  static const CONTENT = 'content';
  static const TIMESTAMP = 'timestamp';
  static const SEEN = 'seen';
  static const PHOTO_POSTED_UID = 'photoPostedUid';

  String? docId; // Firestore auto generated doc Id
  late String commentedBy; // email 
  late String uid;
  late String photoPostedUid;
  late String photoId; 
  late String content;
  late int seen;
  DateTime? timestamp;

  Comment({
    this.docId,
    this.uid = '',
    this.photoPostedUid = '',
    this.commentedBy = '',
    this.photoId = '',
    this.content = '',
    this.timestamp,
    this.seen = 0,
  });

  Comment.clone(Comment p) {
    this.docId = p.docId;
    this.uid = p.uid;
    this.photoPostedUid = p.photoPostedUid;
    this.commentedBy = p.commentedBy;
    this.photoId = p.photoId;
    this.content = p.content;
    this.timestamp = p.timestamp;
    this.seen = p.seen;
  }

  // a.assign(b) =====> a = b
  void assign(Comment p) {
    this.docId = p.docId;
    this.uid = p.uid;
    this.photoPostedUid = p.photoPostedUid;
    this.commentedBy = p.commentedBy;
    this.photoId = p.photoId;
    this.content = p.content;
    this.timestamp = p.timestamp;
    this.seen = p.seen;
  }

  Map<String, dynamic> toFirestoreDoc() {
    return {
      UID: this.uid,
      PHOTO_POSTED_UID: this.photoPostedUid,
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
      photoPostedUid: doc[PHOTO_POSTED_UID],
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
