class SocialUserModel {
  String userName;
  String userEmail;
  String userPhone;
  String userId;
  String userImage;
  String userBio;
  SocialUserModel(
      {this.userId,
      this.userEmail,
      this.userName,
      this.userPhone,
      this.userImage,
      this.userBio});

  SocialUserModel.fromJson(Map<String, dynamic> jsonObject) {
    this.userId = jsonObject["uId"];
    this.userEmail = jsonObject["email"];
    this.userName = jsonObject["name"];
    this.userPhone = jsonObject["phone"];
    this.userImage = jsonObject["image"];
    this.userBio = jsonObject["bio"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uId": this.userId,
      "email": this.userEmail,
      "name": this.userName,
      "phone": this.userPhone,
      "image": this.userImage,
      "bio": this.userBio,
    };
  }
}
