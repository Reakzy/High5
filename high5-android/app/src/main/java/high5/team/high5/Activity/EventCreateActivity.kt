package high5.team.high5.Activity

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.View
import android.widget.EditText
import high5.team.high5.Adapter.EventCreateAdapter
import high5.team.high5.Model.Event
import high5.team.high5.Model.User
import high5.team.high5.R
import kotlinx.android.synthetic.main.activity_event_create.*
import java.util.*
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.util.Log
import android.widget.Button
import java.util.Date
import java.text.SimpleDateFormat


class EventCreateActivity : AppCompatActivity(), View.OnClickListener {

    private val TAG = "EventCreateActivity"

    private var eventCreateAdapter : EventCreateAdapter = EventCreateAdapter(this)

    private var user : User? = null
    private var event : Event? = null

    private var mSubmit : Button? = null
    private var mName : EditText? = null
    private var mEventAt : EditText? = null
    private var mPlace : EditText? = null
    private var mDescription : EditText? = null
    private var mUserMaxNumber : EditText? = null
    private var cal = Calendar.getInstance()

    private var date : high5.team.high5.Utils.Date = high5.team.high5.Utils.Date()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_event_create)

        user = intent.getSerializableExtra("User") as User
        event = intent.getSerializableExtra("Event") as? Event

        mName = findViewById(R.id.txtTitle)
        mEventAt = findViewById(R.id.txtDate)
        mPlace = findViewById(R.id.txtLocation)
        mDescription = findViewById(R.id.description)
        mUserMaxNumber = findViewById(R.id.userMaxNumber)
        mSubmit = findViewById<Button>(R.id.btnSubmit)
        mSubmit!!.text = getString(R.string.event_add)

        // Administrator can edit his event, else redirect
        if (null !== user && null !== event && user!!.id == event!!.createdBy) {
            mName!!.setText(event!!.name)
            mPlace!!.setText(event!!.place)
            mDescription!!.setText(event!!.description)
            mUserMaxNumber!!.setText(event!!.userMaxNumber.toString())
            date.getCalendar(event!!.eventAt, cal)
            mSubmit!!.text = getString(R.string.event_edit)
        } else if (null !== user && null !== event && user!!.id != event!!.createdBy) {
            finish()
            val intent = Intent(this, EventActivity::class.java)
            intent.putExtra("User", user)
            this.startActivity(intent)
        }

        date.updateDateInView(mEventAt, cal)
        val timeSetListener = TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->
            cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
            cal.set(Calendar.MINUTE, minute)
            date.updateDateInView(mEventAt, cal)
            val sdf = SimpleDateFormat("dd/MM/yyyy hh:mm")
            val strDate = sdf.parse(mEventAt?.text.toString())
            if (System.currentTimeMillis() < strDate.getTime()) mEventAt?.error = null
        }

        val dateSetListener = DatePickerDialog.OnDateSetListener { view, year, monthOfYear, dayOfMonth ->
            cal.set(Calendar.YEAR, year)
            cal.set(Calendar.MONTH, monthOfYear)
            cal.set(Calendar.DAY_OF_MONTH, dayOfMonth)
            TimePickerDialog(this@EventCreateActivity, timeSetListener, cal.get(Calendar.HOUR_OF_DAY),  cal.get(Calendar.MINUTE), true).show()
        }

        mEventAt!!.setOnClickListener {
            DatePickerDialog(this@EventCreateActivity,
                dateSetListener,
                // set DatePickerDialog to point to today's date when it loads up
                cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH),
                cal.get(Calendar.DAY_OF_MONTH)).show()
        }
        btnSubmit.setOnClickListener(this)
        btnCancel.setOnClickListener(this)
        navigationView.setOnNavigationItemSelectedListener { item ->
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
                    finish()
                    true
                }
                else -> {
                    finish()
                    false
                }
            }
        }
    }

    override fun onClick(v: View) {
        val i = v.id
        if (null === event) {
            event = Event()
            event!!.waitingUserIds = mutableListOf<String>()
            event!!.addUserId(user?.id.toString())
            event!!.createdBy = user?.id.toString()
            event!!.createdAt = date.utcDate("MM-dd-yyyy HH:mm")
        }

        event!!.name = mName?.text.toString()
        event!!.description = mDescription?.text.toString()
        event!!.eventAt = mEventAt?.text.toString()
        event!!.place = mPlace?.text.toString()
        event!!.updatedAt = event!!.createdAt
        if (mUserMaxNumber?.text.toString() != "") event!!.userMaxNumber = mUserMaxNumber?.text.toString().toInt()
        when (i) {
            R.id.btnCancel -> {
                finish()
            }
            R.id.btnSubmit -> {
                val sdf = SimpleDateFormat("dd/MM/yyyy hh:mm")
                val strDate = sdf.parse(mEventAt?.text.toString())
                if (System.currentTimeMillis() > strDate.getTime()) mEventAt?.error = "La date de l'èvènement ne peut être passée"
                    else  mEventAt?.error = null;
                if (mName?.text.toString() == "") mName?.error = "Vous devez spécifier un nom"
                    else mName?.error = null;
                if (mDescription?.text.toString() == "") mDescription?.error = "Ajoutez une description à votre évènement"
                    else  mDescription?.error = null;
                if (mPlace?.text.toString() == "") mPlace?.error = "Une adresse doit être spécifiée"
                    else  mPlace?.error = null;
                if (mUserMaxNumber?.text.toString() == "") mUserMaxNumber?.error = "Ajoutez une description à votre évènement"
                    else  mUserMaxNumber?.error = null;

                if (mEventAt?.error != null || mName?.error != null || mDescription?.error != null
                    || mPlace?.error != null || mUserMaxNumber?.error != null) return;

                user!!.numberEventCreated++
                eventCreateAdapter.create(event!!, user)
                finish()
                val intent = Intent(this, EventActivity::class.java)
                intent.putExtra("User", user)
                this.startActivity(intent)
            }
        }
    }
}