import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greamit_app/Model/gream.dart';
import 'package:greamit_app/Model/user.dart';
import 'package:greamit_app/Model/userModel.dart';
import 'package:greamit_app/Services/Persistence/PersistentData.dart';
import 'package:greamit_app/Utilities/Constants.dart';

class FirestoreCloudDb {

  final databaseReference = Firestore.instance;

  void writeNewUser({String userID, UserModel userModel}) async {
    await databaseReference
        .collection(FireStoreConstants.USERS)
        .document(userID)
        .setData(userModel.toJson());
  }

  Future<void> updateUserData(
      {String userID, Map<String, dynamic> fieldsToUpdate}) async {
    await databaseReference
        .collection(FireStoreConstants.USERS)
        .document(userID)
        .updateData(fieldsToUpdate);
  }

  Future<DocumentReference> getUserData(String usersID) async {
    return databaseReference
        .collection(FireStoreConstants.USERS)
        .document(usersID);
  }

  DocumentReference getUserDoc(String usersID) {
    return databaseReference.collection(FireStoreConstants.USERS).document(usersID);
  }

  CollectionReference getUsersCollection() {
    return databaseReference.collection(FireStoreConstants.USERS).reference();
  }

  DocumentReference getGreamDoc(String greamsID) {
    return databaseReference.collection(FireStoreConstants.GREAMS).document(greamsID);
  }

  CollectionReference getGreamsCollection() {
    return databaseReference.collection(FireStoreConstants.GREAMS);
  }

  Query getUserGreamsCollection(String userID) {
    return databaseReference.collection(FireStoreConstants.GREAMS).where("postUserID", isEqualTo:  userID);
  }

  Future<void> postGream({String userID, GreamitPost greamitPost}) async {
    return await databaseReference
        .collection(FireStoreConstants.GREAMS)
        .document()
        .setData(greamitPost.toJson());
  }

  Future<void> likeUpdate({String greamDocID, DocumentReference greamDocumentReference, DocumentReference profileDocRef, List<String> likeList}) async {

    if(likeList.isEmpty) {

      await databaseReference.runTransaction((transaction) async {

        DocumentSnapshot snapshot = await transaction.get(greamDocumentReference);

        GreamitPost greamitPost = GreamitPost.fromJson(snapshot.data);

        List<String> likes = greamitPost.likes;

        likes.add(getUser.uID);

        await transaction.update(greamDocumentReference, {
          'likes' : likes,
        });

        addLikedGream(greamDocID, profileDocRef);

      });

    } else {

      if(likeList.contains(getUser.uID)) {

        await databaseReference.runTransaction((transaction) async {

          DocumentSnapshot snapshot = await transaction.get(greamDocumentReference);

          GreamitPost greamitPost = GreamitPost.fromJson(snapshot.data);

          List<String> likes = greamitPost.likes;

          likes.remove(getUser.uID);

          await transaction.update(greamDocumentReference, {
            'likes' : likes,
          });

          removeLikedGream(greamDocID, profileDocRef);

        });

      } else {

        await databaseReference.runTransaction((transaction) async {

          DocumentSnapshot snapshot = await transaction.get(greamDocumentReference);

          GreamitPost greamitPost = GreamitPost.fromJson(snapshot.data);

          List<String> likes = greamitPost.likes;

          likes.add(getUser.uID);

          await transaction.update(greamDocumentReference, {
            'likes' : likes,
          });

          addLikedGream(greamDocID, profileDocRef);

        });

      }

    }

  }

  Future<void> removeLikedGream(String greamDocID, DocumentReference profileDocumentReference) async {

    await databaseReference.runTransaction((transaction) async {

      DocumentSnapshot snapshot = await transaction.get(profileDocumentReference);
      UserModel userModel = UserModel.fromJson(snapshot.data);

      List<String> likedGreams = userModel.likedGreamPosts;

      likedGreams.remove(greamDocID);

      await transaction.update(profileDocumentReference, {
        'likedGreamPosts' : likedGreams
      });

    });

  }

  Future<void> addLikedGream(String greamDocID, DocumentReference profileDocumentReference) async {

    await databaseReference.runTransaction((transaction) async {

      DocumentSnapshot snapshot = await transaction.get(profileDocumentReference);
      UserModel userModel = UserModel.fromJson(snapshot.data);

      List<String> likedGreams = userModel.likedGreamPosts;

      likedGreams.add(greamDocID);

      await transaction.update(profileDocumentReference, {
        'likedGreamPosts' : likedGreams
      });

    });

  }

  Future<void> followProfile({DocumentReference documentReference, DocumentReference usersDocumentReference, List<String> followersList}) async {

    if(followersList.isEmpty) {

      await databaseReference.runTransaction((transaction) async {

        DocumentSnapshot snapshot = await transaction.get(documentReference);

        UserModel userModel = UserModel.fromJson(snapshot.data);

        List<String> followingList = userModel.following;
        followingList.add(usersDocumentReference.documentID);

        await transaction.update(documentReference, {
          'following' : followingList,
        });

        usersDocumentReference.get().then((value) async {

          UserModel followedUserProfile = UserModel.fromJson(value.data);
          await addFollowers(followingID: documentReference.documentID, documentReference: usersDocumentReference, followersList: followedUserProfile.followers);

        });

      });

    } else {

      if(followersList.contains(usersDocumentReference.documentID)) {

        await databaseReference.runTransaction((transaction) async {

          DocumentSnapshot snapshot = await transaction.get(documentReference);
          UserModel userModel = UserModel.fromJson(snapshot.data);

          List<String> followingList = userModel.following;
          followingList.remove(usersDocumentReference.documentID);

          await transaction.update(documentReference, {
            'following' : followingList,
          });

          usersDocumentReference.get().then((value) async {

            UserModel followedUserProfile = UserModel.fromJson(value.data);
            await removeFollowers(followingID: documentReference.documentID, documentReference: usersDocumentReference, followersList: followedUserProfile.followers);

          });

        });

      } else {

        await databaseReference.runTransaction((transaction) async {

          DocumentSnapshot snapshot = await transaction.get(documentReference);

          UserModel userModel = UserModel.fromJson(snapshot.data);

          List<String> followingList = userModel.following;
          followingList.add(usersDocumentReference.documentID);

          await transaction.update(documentReference, {
            'following' : followingList,
          });

          usersDocumentReference.get().then((value) async {

            UserModel followedUserProfile = UserModel.fromJson(value.data);
            await addFollowers(followingID: documentReference.documentID, documentReference: usersDocumentReference, followersList: followedUserProfile.followers);

          });

        });

      }

    }

  }

  Future<void> removeFollowers({String followingID, DocumentReference documentReference, List<String> followersList}) async {

    await databaseReference.runTransaction((transaction) async {

      DocumentSnapshot snapshot = await transaction.get(documentReference);
      UserModel userModel = UserModel.fromJson(snapshot.data);

      List<String> followingList = userModel.following;
      followingList.remove(followingID);

      await transaction.update(documentReference, {
        'followers' : followingList,
      });

    });

  }

  Future<void> addFollowers({String followingID, DocumentReference documentReference, List<String> followersList}) async {

    await databaseReference.runTransaction((transaction) async {

      DocumentSnapshot snapshot = await transaction.get(documentReference);
      UserModel userModel = UserModel.fromJson(snapshot.data);

      List<String> followersList = userModel.following;
      followersList.add(followingID);

      await transaction.update(documentReference, {
        'followers' : followersList,
      });

    });

  }

  Future<void> increaseGreamitPosts({String userID}) async {

    await databaseReference.runTransaction((transaction) async {

      DocumentReference documentReference = getUserDoc(userID);
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      UserModel userModel = UserModel.fromJson(snapshot.data);
      int greamsCounts = userModel.greamPosts;

      await transaction.update(documentReference, {
        'greamPosts' : greamsCounts + 1
      });

    });

  }

  Future<void> addComment({Map<String, dynamic> commentData, DocumentReference greamDocumentReference}) async {

    await databaseReference.runTransaction((transaction) async {

      DocumentSnapshot snapshot = await transaction.get(greamDocumentReference);

      GreamitPost greamitPost = GreamitPost.fromJson(snapshot.data);

      List<Comments> comments = greamitPost.comments;

      Comments commentModel = Comments.fromJson(commentData);

      comments.add(commentModel);

      await transaction.update(greamDocumentReference, {
        'comments' : allCommentToJson(comments),
      });

    });

  }

  bool isLiked({String documentID, List<String> listOfLikes}) {

    if(listOfLikes != null) {

      if(listOfLikes.contains(documentID)) {

        return true;

      }

    } else {

      return false;

    }

    return false;

  }

  bool isFollower({String userID, List<String> listOfFollowers}) {

    if(listOfFollowers != null) {

      if(listOfFollowers.contains(userID)) {

        return true;

      }

    } else {

      return false;

    }

    return false;

  }

  bool isFollowing({String userID, List<String> listOfFollowers}) {

    if(listOfFollowers != null) {

      if(listOfFollowers.contains(userID)) {

        return true;

      }

    } else {

      return false;

    }

    return false;

  }

}
