class SearchModel {
  String _id;
  String _coverImage;
  String _eventName;
  String _title;
  String _status;
  String _type;
  String _category;
  String _createdBy;
  int _endDate;
  List _members;


  List get members => _members;

  set members(List value) {
    _members = value;
  }

  SearchModel(this._id,this._coverImage, this._eventName, this._title, this._status,
      this._type, this._category, this._createdBy,this._endDate,this._members);

  int get endDate => _endDate;

  set endDate(int value) {
    _endDate = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  } // Getter and Setter for coverImage
  String get coverImage => _coverImage;

  set coverImage(String value) {
    _coverImage = value;
  }

  // Getter and Setter for eventName
  String get eventName => _eventName;

  set eventName(String value) {
    _eventName = value;
  }

  // Getter and Setter for title
  String get title => _title;

  set title(String value) {
    _title = value;
  }

  // Getter and Setter for status
  String get status => _status;

  set status(String value) {
    _status = value;
  }

  // Getter and Setter for type
  String get type => _type;

  set type(String value) {
    _type = value;
  }

  // Getter and Setter for category
  String get category => _category;

  set category(String value) {
    _category = value;
  }

  // Getter and Setter for createdBy
  String get createdBy => _createdBy;

  set createdBy(String value) {
    _createdBy = value;
  }
}
