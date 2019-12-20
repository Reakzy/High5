package high5.team.high5.Adapter

import android.util.Log
import com.google.firebase.firestore.*
import high5.team.high5.Model.Event
import high5.team.high5.Model.User

class EventAdapter {

    private val TAG = "EventAdapter"

    private var eventsJoined: MutableList<Event> = mutableListOf()
    private var eventsDisponible: MutableList<Event> = mutableListOf()
    private var eventsSorted: MutableList<Event> = mutableListOf()
    private var changedPosition : Int = 0
    private lateinit var mEventsReference: CollectionReference

    fun getAndSortEvents(user: User, completion: () -> Unit) {
        mEventsReference = FirebaseFirestore.getInstance().collection("Event")

        mEventsReference.orderBy("createdAt", Query.Direction.DESCENDING)
            .addSnapshotListener(EventListener<QuerySnapshot> { result, e ->
                if (e != null) {
                    Log.w(TAG, "Listen failed.", e)
                    return@EventListener
                }
                eventsSorted.clear()
                eventsJoined.clear()
                eventsDisponible.clear()
                if (result != null) {
                    for (document in result) {
                        val eventDatabase = document.toObject(Event::class.java)
                        eventDatabase.id = document.id
                        if (eventDatabase.userIds.contains(user.id))
                            eventsJoined.add(eventDatabase)
                        else
                            eventsDisponible.add(eventDatabase)
                    }
                    changedPosition = eventsJoined.size
                    eventsSorted.addAll(eventsJoined)
                    eventsSorted.addAll(eventsDisponible)
                    completion()
                }
            })
    }

    fun getSortedEvents(): MutableList<Event> {
        return eventsSorted
    }
    fun getChangedPosition(): Int {
        return changedPosition
    }
}
