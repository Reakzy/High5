package high5.team.high5.Adapter

import android.content.Context
import android.content.Intent
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import high5.team.high5.Activity.EventActivity
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R
import java.util.*

class EventCreateAdapter(private val context: Context) {

    private val TAG = "EventCreateAdapter"

    private val userAdapter: UserAdapter = UserAdapter()

    fun create(event: Event, user: User?) {
        if (user === null) {
            return
        }

        val data = HashMap<String, Any>()
        data["name"] = event.name
        data["createdAt"] = event.createdAt
        data["createdBy"] = event.createdBy
        data["groupePicture"] = "https://image.noelshack.com/fichiers/2019/12/2/1552990035-header-bg.jpg"
        data["description"] = event.description
        data["eventAt"] = event.eventAt
        data["place"] = event.place
        data["updatedAt"] = event.updatedAt
        data["userMaxNumber"] = event.userMaxNumber
        data["userIds"] = event.userIds
        data["waitingUserIds"] = event.waitingUserIds
        if (null === event.id || (null !== event.id && "" == event.id)) {
            FirebaseFirestore.getInstance().collection("Event")
                .add(data)
                .addOnSuccessListener { documentReference ->
                    userAdapter.updateUser(user) {
                    }
                    Log.d(TAG, "'Event' written with ID: " + documentReference.id)
                }
                .addOnFailureListener { e ->
                    Log.w(TAG, "Error adding 'Event'", e)
                }
        } else {
            FirebaseFirestore.getInstance().collection("Event").document(event.id!!)
                .set(data)
        }
    }
}
