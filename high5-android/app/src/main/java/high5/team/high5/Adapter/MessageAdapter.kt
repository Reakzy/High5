package high5.team.high5.Adapter

import android.util.Log
import com.google.firebase.firestore.*
import com.google.firebase.firestore.EventListener
import high5.team.high5.Model.Event

import high5.team.high5.Model.Message
import high5.team.high5.Model.User
import java.util.*

private val TAG = "MessageAdapter"

class MessageAdapter {
    private var date : high5.team.high5.Utils.Date = high5.team.high5.Utils.Date()
    private lateinit var mEventsReference: CollectionReference
    private var messageFromEvent: MutableList<Message> = mutableListOf()
    private var users: MutableList<User> = mutableListOf()
    private lateinit var mUsersReference: CollectionReference

    fun catchUsers(event: Event, completion: () -> Unit) {
        mUsersReference = FirebaseFirestore.getInstance().collection("User")
        mUsersReference.get().addOnSuccessListener { result ->
            users.clear()
            for (document in result) {
                val userDatabase = document.toObject(User::class.java)
                userDatabase.id = document.id
                if (event.userIds.contains(userDatabase.id)) {
                    users.add(userDatabase)
                }
            }
            completion()
        }.addOnFailureListener { exception ->
            Log.w(TAG, "Error getting waiting users in event.", exception)
        }
    }

    fun getUsers(): MutableList<User> {
        return this.users
    }

    fun  createFirebaseListener(event: Event, completion: () -> Unit) {
        mEventsReference = FirebaseFirestore.getInstance().collection("Message")

            mEventsReference.orderBy("createdAt", Query.Direction.ASCENDING).whereEqualTo("eventId", event.id)
            .addSnapshotListener(EventListener<QuerySnapshot> { result, e ->
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e)
                    return@EventListener
                }
                messageFromEvent.clear()
                if (result != null) {
                    for (document in result) {
                        val eventDatabase = document.toObject(Message::class.java)
                        messageFromEvent.add(eventDatabase)
                    }
                    completion()
                }
            })
    }

    fun getMessages(): MutableList<Message> {
        return messageFromEvent
    }

    fun writtingMessage(content: String, createdBy: String, eventId: String) {
        val data = HashMap<String, Any>()
        data["content"] = content
        data["createdAt"] = date.utcDate()
        data["createdBy"] = createdBy
        data["eventId"] = eventId

        FirebaseFirestore.getInstance().collection("Message")
            .add(data)
            .addOnSuccessListener { documentReference ->
                Log.d(TAG, "'Event' written with ID: " + documentReference.id)
            }
            .addOnFailureListener { e ->
                Log.w(TAG, "Error adding 'Event'", e)
            }
    }
}
