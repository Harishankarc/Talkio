import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeChat {
  String? message;
  String? from;
  String? to;

  RealtimeChat({
    this.message,
    this.from,
    this.to,
  });

  final currentUser = Supabase.instance.client.auth.currentUser;

  // Function to create a channel and listen for messages based on sender and receiver
  Future<void> listenForMessages() async {
    if (currentUser != null && from != null && to != null) {
      // Create a unique channel based on 'from' and 'to' (you can concatenate both or sort them for uniqueness)
      String channelName = _createChannelName(from!, to!);

      // Create a new channel
      final channel = Supabase.instance.client
          .channel('realtime:messages:$channelName')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'Chats',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'from',
              value: from,
            ),
            callback: (payload) {
              print('Change received: ${payload.toString()}');
            },
          )
          .subscribe();

      // Optionally, you can listen for other events like updates or deletes
      channel.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'Chats',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'to',
          value: to,
        ),
        callback: (payload) {
          print('Update received: ${payload.toString()}');
        },
      );

      channel.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: 'Chats',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'from',
          value: from,
        ),
        callback: (payload) {
          print('Delete received: ${payload.toString()}');
        },
      );
    }
  }

  // Function to generate a unique channel name based on 'from' and 'to'
  String _createChannelName(String from, String to) {
    // Sort the users to create a unique channel name
    List<String> users = [from, to];
    users
        .sort(); // Sorting ensures the channel name is always the same regardless of the sender/receiver order
    return '${users[0]}-${users[1]}';
  }

  // Function to send a message
  Future<void> sendMessage(String message,String to) async {
    if (currentUser != null) {
      // Send the message to the 'Chats' table
      final response = await Supabase.instance.client.from('Chats').insert({
        'from': currentUser!.email,
        'to': to,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      print(response);
    }
  }
}
