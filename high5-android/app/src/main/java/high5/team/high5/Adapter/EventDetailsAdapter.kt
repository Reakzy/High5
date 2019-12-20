package high5.team.high5.Adapter

import android.content.Context
import android.util.Log
import com.google.firebase.firestore.FirebaseFirestore
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import com.google.firebase.firestore.FieldValue

class EventDetailsAdapter(private val context: Context) {

    private val TAG = "EventDetailsAdapter"

    fun addWaitingUser(user: User?, event: Event?) {
        if (null !== user && null !== event && null !== event.id && !event.userIds.contains(user.id)) {
            event.addWaitingUserId(user.id)

            val eventReference = FirebaseFirestore.getInstance().collection("Event").document(event.id!!)

            eventReference.update("waitingUserIds", FieldValue.arrayUnion(user.id))
        }
    }

    fun quit(user: User?, event: Event?) {
        if (null !== user && null !== event && null !== event.id) {
            event.removeUserId(user.id)

            val eventReference = FirebaseFirestore.getInstance().collection("Event").document(event.id!!)

            eventReference.update("waitingUserIds", FieldValue.arrayRemove(user.id))
            eventReference.update("userIds", FieldValue.arrayRemove(user.id))
        }
    }

    fun delete(user: User?, event: Event?) {
        if (null !== user && null !== event && null !== event.id && event.createdBy == user.id) {
            event.removeUserId(user.id)

            val eventReference = FirebaseFirestore.getInstance().collection("Event").document(event.id!!)

            eventReference.delete()
        }
    }
}
