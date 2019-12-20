package high5.team.high5.Adapter

import android.util.Log
import com.google.firebase.firestore.*
import high5.team.high5.Model.User
import java.util.HashMap

class UserAdapter {

    private val TAG = "UserAdapter"

    private var user: User? = null
    private lateinit var mUserReference: CollectionReference

    fun getUserById(userId: String, completion: () -> Unit) {
        mUserReference = FirebaseFirestore.getInstance().collection("User")

        mUserReference.document(userId).get()
            .addOnSuccessListener { document ->
                if (null !== document) {
                    val userDatabase = document.toObject(User::class.java)
                    if (null !== userDatabase) {
                        userDatabase.id = document.id
                        if (userDatabase.id == userId) {
                            user = userDatabase
                        }
                    }
                }

                completion()
            }.addOnFailureListener { exception ->
                Log.w(TAG, "Error getting user by ID.", exception)
            }
    }

    fun getUser(): User? {
        return this.user
    }

    fun updateUser(user: User, completion: () -> Unit) {
        mUserReference = FirebaseFirestore.getInstance().collection("User")


        val data = HashMap<String, Any>()
        data["createdAt"] = user.createdAt
        data["birthdayDate"] = user.birthdayDate
        data["fullName"] = user.fullName
        data["email"] = user.email
        data["profilePicture"] = user.profilePicture
        data["numberEventCreated"] = user.numberEventCreated
        data["numberEventJoined"] = user.numberEventJoined
        mUserReference.document(user.id).set(data)
            .addOnSuccessListener {
                completion()
            }.addOnFailureListener { exception ->
                Log.w(TAG, "Error updating user.", exception)
            }
    }
}
