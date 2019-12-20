package high5.team.high5.Activity

import android.content.Intent
import android.os.Bundle
import android.support.design.widget.BottomNavigationView
import android.support.v7.app.AlertDialog
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.view.View.INVISIBLE
import android.view.View
import android.widget.*
import high5.team.high5.Adapter.EventDetailsAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R
import kotlinx.android.synthetic.main.activity_event_details.*

class EventDetailsActivity : AppCompatActivity(), View.OnClickListener {

    private val TAG = "EventDetailsActivity"
    private var user : User? = null
    private var event : Event? = null
    private var eventDetailsAdapter : EventDetailsAdapter = EventDetailsAdapter(this)


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_details)

        var joinButton = findViewById<Button>(R.id.btnRejoindre) as Button

        user = intent.getSerializableExtra("User") as User
        event = intent.getSerializableExtra("Event") as Event

        if (event != null) {
            name.text = event!!.name
            date.text = event!!.eventAt
            address.text = event!!.place
            description.text = event!!.description
            hour.text = ""
            nbInscrit.text = event!!.userIds.count().toString()
            nbTotalInscrits.text = event!!.userMaxNumber.toString()
        }
        navigationView.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener)
        joinButton.setOnClickListener(this)
        dropdown.setOnClickListener(this)

        if (null !== user && null !== event) {
            if (event!!.userIds.contains(user!!.id)) {
                joinButton.text = getString(R.string.event_chat)
            } else if (event!!.waitingUserIds.contains(user!!.id)) {
                joinButton.isClickable = false
                joinButton.text = getString(R.string.event_waiting)
            } else {
                joinButton.text = getString(R.string.event_join)
                dropdown.visibility = INVISIBLE
                dropdown.isClickable = false
            }
        }
    }

    override fun onClick(v: View) {
        val i = v.id
        when (i) {
            R.id.dropdown -> {
                showPopUp(v)
            }
            R.id.btnRejoindre -> {
                if (null !== user && null !== event) {
                    if (event!!.userIds.contains(user!!.id)) {
                        finish()
                        val intent = Intent(this, ChatActivity::class.java)
                        intent.putExtra("User", user)
                        intent.putExtra("Event", event)
                        this.startActivity(intent)
                    } else if (!event!!.waitingUserIds.contains(user!!.id)) {
                        eventDetailsAdapter.addWaitingUser(user, event)
                        finish()
                        val intent = Intent(this, EventActivity::class.java)
                        intent.putExtra("User", user)
                        this.startActivity(intent)
                    }
                }
            }
        }
    }

    private val mOnNavigationItemSelectedListener = BottomNavigationView.OnNavigationItemSelectedListener { item ->
        when (item.itemId) {
            R.id.navigation_profile -> {
                val intent = Intent(this, ProfileActivity::class.java)
                intent.putExtra("User", user)
                this.startActivity(intent)
                finish()
                true
            }
            R.id.navigation_home -> {
                finish()
                true
            }
            R.id.navigation_add_event -> {
                val intent = Intent(this, EventCreateActivity::class.java)
                intent.putExtra("User", user)
                finish()
                this.startActivity(intent)
                true
            }
            else -> {
                return@OnNavigationItemSelectedListener false
            }
        }
    }

    fun showPopUp(view: View) {
        val popupMenu = PopupMenu(this, view)
        val inflater = popupMenu.menuInflater
        inflater.inflate(R.layout.activity_event_menu, popupMenu.menu)
        popupMenu.menu.clear()

        if (null !== user && null !== event) {
            if (event!!.createdBy == user!!.id) {
                popupMenu.menu.add(1, R.id.quit,1, getString(R.string.event_delete))
                popupMenu.menu.add(1, R.id.waiting_list,2,getString(R.string.event_waiting_list))
                popupMenu.menu.add(1, R.id.edit_event,3,getString(R.string.event_edit))
            } else if (event!!.isInEvent(user!!.id)) {
                popupMenu.menu.add(1, R.id.quit,1,getString(R.string.event_quit))
            }
        }

        popupMenu.show()

        popupMenu.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.quit -> {
                    val builder = AlertDialog.Builder(this)
                    if (event!!.createdBy == user!!.id) {
                        builder.setTitle(getString(R.string.event_delete))
                        builder.setMessage(getString(R.string.event_details_confirm_delete))
                        builder.setPositiveButton(getString(R.string.validation_yes)) { _, _ ->
                            eventDetailsAdapter.delete(user, event)
                            finish()
                            val intent = Intent(this, EventActivity::class.java)
                            intent.putExtra("User", user)
                            this.startActivity(intent)
                        }
                        builder.setNegativeButton(getString(R.string.validation_no)) { _, _ ->
                        }
                    } else {
                        builder.setTitle(getString(R.string.event_quit))
                        builder.setMessage(getString(R.string.event_details_confirm_quit))
                        builder.setPositiveButton(getString(R.string.validation_yes)) { _, _ ->
                            eventDetailsAdapter.quit(user, event)
                            finish()
                            val intent = Intent(this, EventActivity::class.java)
                            intent.putExtra("User", user)
                            this.startActivity(intent)
                        }
                        builder.setNegativeButton(getString(R.string.validation_no)) { _, _ ->
                        }
                    }

                    val dialog: AlertDialog = builder.create()
                    dialog.show()
                }
                R.id.waiting_list -> {
                    if (event!!.createdBy == user!!.id) {
                        val intent = Intent(this, EventWaitingQueueActivity::class.java)
                        intent.putExtra("User", user)
                        intent.putExtra("Event", event)
                        this.startActivity(intent)
                    }
                }
                R.id.edit_event -> {
                    val intent = Intent(this, EventCreateActivity::class.java)
                    intent.putExtra("User", user)
                    intent.putExtra("Event", event)
                    this.startActivity(intent)
                }
            }
            true
        }
    }
}