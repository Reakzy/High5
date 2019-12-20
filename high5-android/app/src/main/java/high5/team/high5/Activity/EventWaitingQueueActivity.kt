package high5.team.high5.Activity

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.widget.ListView
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R
import high5.team.high5.Adapter.EventWaitingQueueAdapter
import high5.team.high5.View.EventWaitingQueueView
import kotlinx.android.synthetic.main.activity_event_list.*

class EventWaitingQueueActivity : AppCompatActivity() {

    private val TAG = "EventWaitingQueueActivity"

    private var lv: ListView? = null

    private var customeViewAdapter: EventWaitingQueueView? = null

    private var eventWaitingQueueAdapter: EventWaitingQueueAdapter = EventWaitingQueueAdapter()

    private var user: User? = null
    private var event: Event? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_waiting_list)

        lv = findViewById(R.id.listView)

        user = intent.getSerializableExtra("User") as? User
        event = intent.getSerializableExtra("Event") as? Event

        if (null !== event) {
            eventWaitingQueueAdapter.catchWaitingUsers(event!!) {
                customeViewAdapter =
                        EventWaitingQueueView(applicationContext, eventWaitingQueueAdapter.getWaitingUsers(), user!!, eventWaitingQueueAdapter, event!!)
                if (customeViewAdapter != null)
                    lv!!.adapter = customeViewAdapter
            }
        }
        navigationView.setOnNavigationItemSelectedListener { item ->
            when (item.itemId) {
                R.id.navigation_profile -> {
                    finish()
                    val intent = Intent(this, ProfileActivity::class.java)
                    intent.putExtra("User", user)
                    this.startActivity(intent)
                    true
                }
                R.id.navigation_home -> {
                    finish()
                    val intent = Intent(this, EventActivity::class.java)
                    intent.putExtra("User", user)
                    this.startActivity(intent)
                    true
                }
                R.id.navigation_add_event -> {
                    finish()
                    val intent = Intent(this, EventCreateActivity::class.java)
                    intent.putExtra("User", user)
                    this.startActivity(intent)
                    true
                }
                else -> {
                    false
                }
            }
        }
    }
}