import 'package:flutter_test/flutter_test.dart';
import 'package:chating_app/app/model/chat_model.dart';

void main() {
  test('ChatMessageModel parses JSON from API successfully', () {
    final apiResponse = {
      "id": 1,
      "room_id": 1,
      "sender_id": 3,
      "content": "hey",
      "created_at": "2026-06-08T11:21:52.114Z",
      "username": "jayesh_h410"
    };

    final message = ChatMessageModel.fromJson(apiResponse, "3");

    expect(message.id, 1);
    expect(message.roomId, 1);
    expect(message.senderId, "3");
    expect(message.content, "hey");
    expect(message.username, "jayesh_h410");
    expect(message.isMe, true);
  });
}
