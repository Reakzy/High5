package high5.team.high5.Activity

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.os.Bundle
import android.support.design.widget.BottomNavigationView
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.DatePicker
import android.widget.EditText
import android.widget.TextView
import com.squareup.picasso.Picasso
import high5.team.high5.Adapter.UserAdapter
import high5.team.high5.Model.User
import high5.team.high5.R
import kotlinx.android.synthetic.main.activity_profile.*
import java.util.*

class ProfileEditActivity : AppCompatActivity() {

    private val TAG = "ProfileEditActivity"

    private var isNewUser : Boolean? = false
    private var user : User? = null
    private var userAdapter: UserAdapter = UserAdapter()
    private var cal = Calendar.getInstance()
    private var date : high5.team.high5.Utils.Date = high5.team.high5.Utils.Date()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_edit_profile)

        isNewUser = intent.getSerializableExtra("isNewUser") as? Boolean
        user = intent.getSerializableExtra("User") as? User

        val newUser = User()
        val name = findViewById<EditText>(R.id.name) as TextView
        val birthdayDate = findViewById<EditText>(R.id.birthdayDate) as EditText
        val email = findViewById<EditText>(R.id.email) as TextView
        if (null !== user) {
            Picasso.get().load(user!!.profilePicture).into(profile) // select the ImageView to load it into
            name.text = user!!.fullName
            email.text = user!!.email

            newUser.id = user!!.id
            newUser.email = user!!.email
            newUser.fullName = user!!.fullName
            newUser.createdAt = user!!.createdAt
            newUser.birthdayDate = user!!.birthdayDate
            newUser.profilePicture = user!!.profilePicture
        }

        val dateSetListener = DatePickerDialog.OnDateSetListener { view, year, monthOfYear, dayOfMonth ->
            cal.set(Calendar.YEAR, year)
            cal.set(Calendar.MONTH, monthOfYear)
            cal.set(Calendar.DAY_OF_MONTH, dayOfMonth)
            cal.set(Calendar.HOUR, 0)
            cal.set(Calendar.MINUTE, 0)
            date.updateDateInView(birthdayDate, cal, "dd/MM/yyyy")
        }

        birthdayDate.setOnClickListener {
            DatePickerDialog(this@ProfileEditActivity,
                dateSetListener,
                // set DatePickerDialog to point to today's date when it loads up
                cal.get(Calendar.YEAR),
                cal.get(Calendar.MONTH),
                cal.get(Calendar.DAY_OF_MONTH)).show()
        }

        val saveButton = findViewById<Button>(R.id.saveButton) as Button
        saveButton.setOnClickListener {
            newUser.fullName = name.text.toString()

            newUser.birthdayDate = date.updateDate("MM-dd-YYYY HH:mm", cal)!!
            userAdapter.updateUser(newUser) {
                val intent = Intent(this, EventActivity::class.java)
                intent.putExtra("User", newUser)
                this.startActivity(intent)
            }
        }
        if (null !== isNewUser && isNewUser!!) {
            navigationView.isClickable = false
            navigationView.visibility = View.INVISIBLE
        }
        navigationView.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener)
    }

    private val mOnNavigationItemSelectedListener = BottomNavigationView.OnNavigationItemSelectedListener { item ->
        when (item.itemId) {
            R.id.navigation_profile -> {
                true
            }
            R.id.navigation_home -> {
                finish()
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
                return@OnNavigationItemSelectedListener false
            }
        }
    }
}