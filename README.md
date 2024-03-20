# chat_test

Flutter android chat app 

## Getting Started

#Features:


● Two screens representing different users, each containing a chat list.
● Real-time messaging functionality.
● Simple navigation between screens using a bottom navigation bar.
● Floating action button to start a new conversation, which creates the chat in both pages.
● Indicator of the number of new messages for each chat list tile.
● Bidirectional communication between the two screens.

#Backend: 


FirbaseFirestore
|
|____ collection("test_chats")
     |
     |____ doc(chatId)
          |
          |____ lastMessage (Map)
                collection("messages")
                |
                |____doc("messageId")
                     |
                     |____message (Map)
                
                


