package high5.team.high5.Adapter

import android.util.Log
import com.google.firebase.firestore.*
import high5.team.high5.Model.Event
import high5.team.high5.Model.User

class EventWaitingQueueAdapter {
    private val TAG = "EventWaitingAdapter"
    private var waitingUsers: MutableList<User> = mutableListOf()
    private var waitingUserIds: MutableList<String> = mutableListOf()
    private lateinit var mUsersReference: CollectionReference
    private lateinit var mEventReference: CollectionReference
    private val userAdapter: UserAdapter = UserAdapter()

    fun catchWaitingUsers(event: Event, completion: () -> Unit) {
        mEventReference = FirebaseFirestore.getInstance().collection("Event")
        mEventReference
            .addSnapshotListener(EventListener<QuerySnapshot> { result, e ->
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e)
                    return@EventListener
                }

                if (result != null) {
                    waitingUsers.clear()
                    waitingUserIds.clear()
                    // Searching the event and looping on its waitingUserIds
                    for (document in result) {
                        if (event.id == document.id) {
                            val eventDatabase = document.toObject(Event::class.java)
                            eventDatabase.id = document.id

                            for (waitingUserId in eventDatabase.waitingUserIds) {
                                waitingUserIds.add(waitingUserId)
                            }

                            event.waitingUserIds = waitingUserIds
                            // Searching all users from ids
                            mUsersReference = FirebaseFirestore.getInstance().collection("User")
                            mUsersReference.get()
                                .addOnSuccessListener {userResult ->
                                    if (null !== userResult) {
                                        for (userDocument in userResult) {
                                            if (waitingUserIds.contains(userDocument.id)) {
                                                val userDatabase = userDocument.toObject(User::class.java)
                                                userDatabase.id = userDocument.id
                                                waitingUsers.add(userDatabase)
                                            }
                                        }
                                    }

                                    completion()
                                }
                        }
                    }
                }
            })
    }

    fun getWaitingUsers(): MutableList<User> {
        return this.waitingUsers
    }

    fun addWaitingUserToEvent(event: Event, user: User): Boolean {
        if (!event.userIds.contains(user.id)) {
            event.addUserId(user.id)
            event.removeWaitingUserId(user.id)
            val eventReference = FirebaseFirestore.getInstance().collection("Event").document(event.id!!)

            eventReference.update("userIds", FieldValue.arrayUnion(user.id))
                .addOnSuccessListener {
                    eventReference.update("waitingUserIds", FieldValue.arrayRemove(user.id))

                    user.numberEventJoined++
                    userAdapter.updateUser(user) {}
                }


            return true
        }

        return false
    }

    fun removeWaitingUserToEvent(event: Event, user: User): Boolean {
        if (event.waitingUserIds.contains(user.id)) {
            event.removeWaitingUserId(user.id)

            val eventReference = FirebaseFirestore.getInstance().collection("Event").document(event.id!!)

            eventReference.update("waitingUserIds", FieldValue.arrayRemove(user.id))

            return true
        }

        return false
    }
}
