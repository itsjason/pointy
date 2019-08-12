// Generated by itsjason
// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Room {

  String id;
	String name;
	Timestamp createdAt;
	String ownerId;
	List<String> users;

	Room({this.name, this.createdAt, this.ownerId, this.users});

  Room.fromMap(String id, Map<dynamic, dynamic> map)
      : id = id,
      name = map['name'],
			createdAt = map['createdAt'],
			ownerId = map['ownerId'],
			users = map['users'];

  Map<String, dynamic> toMap() => {
    "id": this.id, 
    "name": this.name,
		"createdAt": this.createdAt,
		"ownerId": this.ownerId,
		"users": this.users  };

  @override
  String toString() => "Room<id:$id>";

  static StreamTransformer<DocumentSnapshot, Room> getTransformer() {
    final trans = StreamTransformer.fromHandlers(
        handleData: (DocumentSnapshot snapshot, EventSink<Room> sink) {
      if (snapshot.data == null) return;

      final result = Room.fromMap(snapshot.documentID, snapshot.data);
      sink.add(result);
    });
    return trans;
  }

  static Stream<Room> getDocumentStream(Firestore firestore, String path) {
    final transformer =
        firestore.document(path).snapshots().transform(getTransformer());
    return transformer;
  }

  static Stream<Map<String, Room>> getCollectionStream(
      Firestore firestore, String path) {
    final transformer = firestore.collection(path).snapshots().transform(
        StreamTransformer.fromHandlers(handleData: handleCollectionTransform));
    return transformer;
  }

  static void handleCollectionTransform(
      QuerySnapshot snapshot, EventSink<Map<String, Room>> sink) {
    var result = Map<String, Room>();
    snapshot.documents.forEach((doc) {
      result[doc.documentID] = Room.fromMap(doc.documentID, doc.data);
    });
    sink.add(result);
  }
}
    