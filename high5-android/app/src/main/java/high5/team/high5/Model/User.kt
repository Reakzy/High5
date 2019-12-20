package high5.team.high5.Model

import java.io.Serializable
import java.util.*

class User : Serializable
{
    var id: String = ""
    var createdAt: String = ""
    var birthdayDate: String = ""
    var fullName: String = ""
    var email: String = ""
    var profilePicture: String = ""
    var numberEventCreated: Int = 0
    var numberEventJoined: Int = 0
}