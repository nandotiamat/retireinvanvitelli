class ChatData {
  final String avatarUrl;
  final String chatTitle;
  final String lastMessage;
  final int numberOfUnreadMessages;
  final String lastMessageTime;

  ChatData(
      {required this.chatTitle,
      required this.lastMessage,
      required this.avatarUrl,
      required this.numberOfUnreadMessages,
      required this.lastMessageTime});
}
