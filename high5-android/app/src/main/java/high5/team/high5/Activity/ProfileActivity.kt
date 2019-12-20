package high5.team.high5.Activity

import android.content.Intent
import android.os.Bundle
import android.support.design.widget.BottomNavigationView
import android.support.v7.app.AlertDialog
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.widget.Button
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.squareup.picasso.Picasso
import high5.team.high5.Model.User
import high5.team.high5.R
import high5.team.high5.Utils.Date
import kotlinx.android.synthetic.main.activity_profile.*
import kotlinx.android.synthetic.main.activity_profile.view.*
import java.util.*

class ProfileActivity : AppCompatActivity() {

    private val TAG = "ProfileActivity : "

    private var user : User? = null

    private var buttonModify : Button? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)

        buttonModify = findViewById(R.id.modify_account)

        buttonModify!!.setOnClickListener {
            val intent = Intent(this, ProfileEditActivity::class.java)
            intent.putExtra("User", user)
            this.startActivity(intent)
        }

        user = intent.getSerializableExtra("User") as User

        if (user != null)
        {
            Picasso.get().load(user!!.profilePicture).into(profile) // select the ImageView to load it into
            name.text = user!!.fullName
            email.text = user!!.email
            created.text = user!!.numberEventCreated.toString()
            participated.text = user!!.numberEventJoined.toString()
            val date = Date()
            age.text = date.transformDbToView(user!!.birthdayDate, "dd/MM/yyyy")
        }

        Disconnect.setOnClickListener {
            Log.d(TAG, "user disconnected")
            FirebaseAuth.getInstance().signOut()
            val intent = Intent(this, LoginActivity::class.java)
            this.startActivity(intent)
        }

        delete_account.setOnClickListener {
            val firebaseUser = FirebaseAuth.getInstance().currentUser

            val builder = AlertDialog.Builder(this)
            builder.setTitle(getString(R.string.user_profile_confirm_delete_title))
            builder.setMessage(getString(R.string.user_profile_confirm_delete))
            builder.setPositiveButton(getString(R.string.validation_yes)){ _, _ ->
                firebaseUser?.delete()
                    ?.addOnCompleteListener { task ->
                        if (task.isSuccessful) {
                            val intent = Intent(this, LoginActivity::class.java)
                            this.startActivity(intent)
                        }

                        val userReference = FirebaseFirestore.getInstance().collection("User").document(user!!.id)
                        userReference.delete()
                    }
            }
            builder.setNegativeButton(getString(R.string.validation_no)) { _, _ ->
            }
            val dialog: AlertDialog = builder.create()
            dialog.show()

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