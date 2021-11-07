class Constant {
  static const DEV = true;
  static const DARKMODE = true;
  static const PHOTO_IMAGES_FOLDER = 'photo_images';
  static const PHOTOMEMO_COLLECTION = 'photomemo_collection';
  static const BIO_COLLECTION = 'bio_collection';
  static const FAVORITE_COLLECTION = 'favorite_collection';
  static const COMMENT_COLLECTION = 'comment_collection';
}

enum ARGS {
  USER,
  DownloadURL,
  Filename,
  PhotoMemoList,
  OnePhotoMemo,
  Profile,
  NumberOfPhotos,
  isPhotoSaved,
  commentList,
}

enum Sort {
  Title_A_Z,
  Title_Z_A,
  Newest_Comments,
  Most_Recent,
}